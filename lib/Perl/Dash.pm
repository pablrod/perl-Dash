use strict;
use warnings;

package Perl::Dash;

# VERSION

# ABSTRACT: Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

use Mojo::Base 'Mojolicious';
use JSON;

has app_name => __PACKAGE__;

has external_stylesheets => sub { [] };

has layout => sub { {} };

has callbacks => sub { [] };

sub callback {
    my $self     = shift;
    my %callback = @_;

    # TODO check_callback
    push @{ $self->callbacks }, \%callback;
    return $self;
}

sub startup {
    my $self = shift;

    my $renderer = $self->renderer;
    push @{ $renderer->classes }, __PACKAGE__;

    my $r = $self->routes;
    $r->get(
        '/' => sub {
            my $c = shift;
            $c->render( template => 'index' );
        }
    );

    $r->get(
        '/_favicon.ico' => sub {
            my $c = shift;
            $c->reply->file('favicon.ico');
        }
    );

    $r->get(
        '/_dash-layout' => sub {
            my $c = shift;
            $c->render(
                        json => {
                                "props" => {
                                    "children" => [
                                        { "props" => { "id" => "my-id", "value" => "initial value", "type" => "text" },
                                          "type"  => "Input",
                                          "namespace" => "dash_core_components"
                                        },
                                        { "props"     => { "children" => JSON::null, "id" => "my-div" },
                                          "type"      => "Div",
                                          "namespace" => "dash_html_components"
                                        }
                                    ]
                                },
                                "type"      => "Div",
                                "namespace" => "dash_html_components"
                        }
            );
        }
    );

    $r->get(
        '/_dash-dependencies' => sub {
            my $c            = shift;
            my $dependencies = [];
            for my $callback ( @{ $self->callbacks } ) {
                my $rendered_callback = { state => [], clientside_function => JSON::null };
                my $inputs            = [];
                for my $input ( @{ $callback->{Inputs} } ) {
                    my $rendered_input = { id       => $input->{component_id},
                                           property => $input->{component_property}
                    };
                    push @$inputs, $rendered_input;
                }
                $rendered_callback->{inputs} = $inputs;
                $rendered_callback->{'output'} =
                  join( '.', $callback->{'Output'}{component_id}, $callback->{'Output'}{component_property} );
                push @$dependencies, $rendered_callback;
            }
            $c->render(
                json => $dependencies

                  #  [
                  #{  "clientside_function" => JSON::null,
                  #   "inputs"              => [ { "id" => "my-id", "property" => "value" } ],
                  #   "output"              => "my-div.children",
                  #   "state"               => []
                  #}
                  #]
            );
        }
    );

    $r->post(
        '/_dash-update-component' => sub {
            my $c = shift;

            # {"output":"my-div.children","changedPropIds":["my-id.value"],"inputs":[{"id":"my-id","property":"value","value":"initial value"}]}
            #{"response": {"props": {"children": "You've entered \"initial value\""}}}
            my $request = $c->req->json;

            # Searching callbacks by 'changePropdIds'
            my $callbacks = $self->_search_callback( $request->{'changedPropIds'} );
            if ( scalar @$callbacks > 1 ) {
                die 'Not implemented multiple callbacks';
            } elsif ( scalar @$callbacks == 1 ) {
                my $callback           = $callbacks->[0];
                my @callback_arguments = ();
                for my $callback_input ( @{ $callback->{Inputs} } ) {
                    my ( $component_id, $component_property ) = @{$callback_input}{qw(component_id component_property)};
                    for my $change_input ( @{ $request->{inputs} } ) {
                        my ( $id, $property, $value ) = @{$change_input}{qw(id property value)};
                        if ( $component_id eq $id && $component_property eq $property ) {
                            push @callback_arguments, $value;
                            last;
                        }
                    }
                }
                my $updated_value    = $callback->{callback}(@callback_arguments);
                my $updated_property = ( split( /\./, $request->{output} ) )[-1];
                my $props_updated    = { $updated_property => $updated_value };
                $c->render( json => { response => { props => $props_updated } } );
            }
        }
    );

    return $self;
}

sub run_server {
    my $self = shift;
    $self->start('daemon', '-l', 'http://*:8080');
}

sub _search_callback {
    my $self             = shift;
    my $changed_prop_ids = shift;

    my $callbacks          = $self->callbacks;
    my @matching_callbacks = ();
    for my $changed_prop_id (@$changed_prop_ids) {
        for my $callback (@$callbacks) {
            my $inputs = $callback->{Inputs};
            for my $input (@$inputs) {
                if ( $changed_prop_id eq join( '.', @{$input}{qw(component_id component_property)} ) ) {
                    push @matching_callbacks, $callback;
                    last;
                }
            }
        }
    }

    return \@matching_callbacks;
}

1;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Renderer';
<div id="react-entry-point">
    <div class="_dash-loading">
        Loading...
    </div>
</div>

        <footer>
            <script id="_dash-config" type="application/json">{"url_base_pathname": null, "requests_pathname_prefix": "/", "ui": false, "props_check": false, "show_undo_redo": false}</script>
            <script src="/_dash-component-suites/dash_renderer/polyfill@7.v1_2_2m1574885967.7.0.min.js"></script>
<script src="/_dash-component-suites/dash_renderer/react@16.v1_2_2m1574885967.8.6.min.js"></script>
<script src="/_dash-component-suites/dash_renderer/react-dom@16.v1_2_2m1574885967.8.6.min.js"></script>
<script src="/_dash-component-suites/dash_renderer/prop-types@15.v1_2_2m1574885967.7.2.min.js"></script>
<script src="/_dash-component-suites/dash_html_components/dash_html_components.v1_0_2m1573762545.min.js"></script>
<script src="/_dash-component-suites/dash_core_components/highlight.v1_6_0m1574883968.pack.js"></script>
<script src="/_dash-component-suites/dash_core_components/dash_core_components.v1_6_0m1574883964.min.js"></script>
<script src="/_dash-component-suites/dash_renderer/dash_renderer.v1_2_2m1574885976.min.js"></script>
            <script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>
        </footer>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta charset="UTF-8">
        <title><%= title %></title>
        <link rel="icon" type="image/x-icon" href="/_favicon.ico?v=1.7.0">
        <link rel="stylesheet" href="https://codepen.io/chriddyp/pen/bWLwgP.css">
    </head>
    <body>
        
  <%= content %>
    </body>
</html>
