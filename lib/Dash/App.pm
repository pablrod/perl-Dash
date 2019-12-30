package Dash::App;

use strict;
use warnings;

# VERSION

# ABSTRACT: Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

# TODO Enable signatures?

use Mojo::Base 'Mojolicious';
use JSON;
use Browser::Open;
use File::ShareDir;
# TODO Use Mojo::File (Mojo::Path) instead of Path::Tiny
# # TODO Use Mojo::File (Mojo::Path) instead of Path::Tiny
use Path::Tiny;
use Dash::Renderer;

# TODO Add ci badges

=pod
=encoding utf8

=head1 DESCRIPTION

This library is a port of L<Plotly's Dash|https://dash.plot.ly/> to Perl. As
the official doc says: I<Dash is a productive Python framework for building web applications>.

This Perl packge is a humble atempt to ease the task of building data visualization web apps in Perl.
The ultimate goal of course is to support everything that the Python version supports.

=head1 SYNOPSIS

# EXAMPLE: examples/basic_callbacks.pl

# EXAMPLE: examples/random_chart.pl

=cut

has app_name => __PACKAGE__;

has external_stylesheets => sub { [] };

has layout => sub { {} };

has callbacks => sub { [] };

has '_rendered_scripts';

has '_rendered_external_stylesheets';

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
            $c->stash(
                stylesheets => $self->_rendered_stylesheets,
                external_stylesheets => $self->_rendered_external_stylesheets,
                scripts => $self->_rendered_scripts,
                title => $self->app_name);
            $c->render( template => 'index' );
        }
    );

    my $dist_name = 'Dash';
    $r->get('/_dash-component-suites/:namespace/*asset' => sub {
            my $c = shift;
            $c->reply->file(File::ShareDir::dist_file($dist_name, Path::Tiny::path('assets', $c->stash('namespace'), $c->stash('asset'))->canonpath ));
        } 
    );

    $r->get(
        '/_favicon.ico' => sub {
            my $c = shift;
            $c->reply->file( File::ShareDir::dist_file($dist_name, 'favicon.ico'));
        }
    );

    $r->get(
        '/_dash-layout' => sub {
            my $c = shift;
            $c->render(
                        json => $self->layout()
            );
        }
    );

    $r->get(
        '/_dash-dependencies' => sub {
            my $c            = shift;
            my $dependencies = [];
            for my $callback ( @{ $self->callbacks } ) {
                # TODO Handle state
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
            );
        }
    );

    $r->post(
        '/_dash-update-component' => sub {
            my $c = shift;

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

    $self->_render_and_cache_scripts();
    $self->_render_and_cache_external_stylesheets();

    # Opening the browser before starting the daemon works because
    #  open_browser returns inmediately
    # TODO Open browser optional
    Browser::Open::open_browser('http://127.0.0.1:8080');
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

sub _rendered_stylesheets {
    return '';
}

sub _render_external_stylesheets {
    my $self = shift;
    my $stylesheets = $self->external_stylesheets;
    my $rendered_external_stylesheets = "";
    for my $stylesheet (@$stylesheets) {
        $rendered_external_stylesheets .= '<link rel="stylesheet" href="' . $stylesheet . '">' . "\n";
    }
    return $rendered_external_stylesheets;
}

sub _render_and_cache_external_stylesheets {
    my $self = shift;
    my $stylesheets = $self->_render_external_stylesheets();
    $self->_rendered_external_stylesheets($stylesheets);
}

sub _render_and_cache_scripts {
    my $self = shift;
    my $scripts = $self->_render_scripts();
    $self->_rendered_scripts($scripts);
}

sub _render_dash_config {
    return
            '<script id="_dash-config" type="application/json">{"url_base_pathname": null, "requests_pathname_prefix": "/", "ui": false, "props_check": false, "show_undo_redo": false}</script>';
}

sub _dash_renderer_js_dependencies {
    my $js_dist_dependencies = Dash::Renderer::_js_dist_dependencies();
    my @js_deps = ();
    for my $deps (@$js_dist_dependencies) {
        my $external_url = $deps->{external_url};
        my $relative_package_path = $deps->{relative_package_path};
        my $namespace = $deps->{namespace};
        my $dep_count = 0;
        for my $dep (@{$relative_package_path->{prod}}) {
            my $js_dep = {
                namespace => $namespace,
                relative_package_path => $dep,
                dev_package_path => $relative_package_path->{dev}[$dep_count],
                external_url => $external_url->{prod}[$dep_count]
                };
            push @js_deps, $js_dep;
            $dep_count++;
        }
    }
     \@js_deps;
}

sub _dash_renderer_js_deps {
    return Dash::Renderer::_js_dist();
}

sub _render_dash_renderer_script {
    return '<script id="_dash-renderer" type="application/javascript">var renderer = new DashRenderer();</script>';
}

sub _render_scripts {
    my $self = shift;

    # First dash_renderer dependencies
    my $scripts_dependendencies = $self->_dash_renderer_js_dependencies;

    # Traverse layout and recover javascript dependencies
    my $layout = $self->layout;

    my $visitor;
    my $stack_depth_limit = 1000;
    $visitor = sub {
        my $node = shift;
        my $stack_depth = shift;
        if ($stack_depth++ >= $stack_depth_limit) {
            # TODO warn user that layout is too deep
            return;
        }
        my $type = ref $node;
        if ($type eq 'HASH') {
            for my $key (keys %$node) {
                $visitor->($node->{$key}, $stack_depth);
            }
        } elsif ($type eq 'ARRAY') {
            for my $element (@$node) {
                $visitor->($element, $stack_depth);
            }
        } elsif ( $type ne '') {
            my $node_dependencies = $node->_js_dist();
            push @$scripts_dependendencies, @$node_dependencies if defined $node_dependencies;
            if ($node->can('children')) {
                $visitor->($node->children, $stack_depth);
            }
        }
    };

    $visitor->($layout, 0);
   
    my $rendered_scripts = "";
    $rendered_scripts .= $self->_render_dash_config();
    push @$scripts_dependendencies, @{$self->_dash_renderer_js_deps()};
    # TODO Avoid duplicates
    for my $dep (@$scripts_dependendencies) {
        $rendered_scripts .= '<script src="/' . join("/", '_dash-component-suites', $dep->{namespace}, $dep->{relative_package_path}) . '"></script>' . "\n";
    }
    $rendered_scripts .= $self->_render_dash_renderer_script();

    return $rendered_scripts;
}

1;

=head1 STATUS

At this moment this library is experimental and still under active
development and the API is going to change!

The intent of this release is to try, test and learn how to improve it.

If you want to help, just get in contact! Every contribution is welcome!


=head1 DISCLAIMER

This is an unofficial Plotly Perl module. Currently I'm not affiliated in any way with Plotly. 
But I think Dash is a great library and I want to use it with perl.

If you like Dash please consider supporting them purchasing professional services: L<Dash Enterprise|https://plot.ly/dash/>

=head1 SEE ALSO

L<Dash|https://dash.plot.ly/>
L<Dash Repository|https://github.com/plotly/dash>
L<Chart::Plotly>
L<Chart::GGPlot>
L<Alt::Data::Frame::ButMore>

=cut

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
            <%== $scripts %>
        </footer>


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta charset="UTF-8">
        <title><%= $title %></title>
        <link rel="icon" type="image/x-icon" href="/_favicon.ico?v=1.7.0">
        <%== $stylesheets %>
        <%== $external_stylesheets %>
    </head>
    <body>
        
  <%= content %>
    </body>
</html>


