package Dash::Backend::Mojolicious::App;

use Mojo::Base 'Mojolicious';
use Try::Tiny;
use File::ShareDir 1.116;
use Path::Tiny;
use Scalar::Util;

has 'dash_app';

sub startup {
    my $self = shift;

    my $renderer = $self->renderer;
    push @{ $renderer->classes }, 'Dash';


    my $r = $self->routes;
    $r->get(
        '/' => sub {
            my $c = shift;
            $c->stash(
                stylesheets => $self->dash_app->_rendered_stylesheets,
                external_stylesheets => $self->dash_app->_rendered_external_stylesheets,
                scripts => $self->dash_app->_rendered_scripts,
                title => $self->dash_app->app_name);
            $c->render( template => 'index' );
        }
    );

    my $dist_name = 'Dash';
    $r->get('/_dash-component-suites/:namespace/*asset' => sub {
            # TODO Component registry to find assets file in other dists
            my $c = shift;
            my $file = $self->dash_app->_filename_from_file_with_fingerprint($c->stash('asset'));

            $c->reply->file(File::ShareDir::dist_file($dist_name, Path::Tiny::path('assets', $c->stash('namespace'), $file)->canonpath ));
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
                        json => $self->dash_app->layout()
            );
        }
    );

    $r->get(
        '/_dash-dependencies' => sub {
            my $c            = shift;
            my $dependencies = $self->dash_app->_dependencies();
            $c->render(
                json => $dependencies
            );
        }
    );

    $r->post(
        '/_dash-update-component' => sub {
            my $c = shift;

            my $request = $c->req->json;
            try {
                my $content = $self->dash_app->_update_component($request);
                $c->render( json => $content);
            } catch {
                if ( Scalar::Util::blessed $_ && $_->isa('Dash::Exceptions::PreventUpdate') ) {
                    $c->render(status => 204, json => '');
                }
                else {
                    die $_;
                }
            };
        }
    );

    return $self;
}

1;
