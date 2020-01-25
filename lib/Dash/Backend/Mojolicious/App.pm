package Dash::Backend::Mojolicious::App;

use Mojo::Base 'Mojolicious';
use Dash::Backend::Mojolicious::Setup;

has 'dash_app';

sub startup {
    my $self = shift;

    my $setup = Dash::Backend::Mojolicious::Setup->new();
    $setup->register_app($self->renderer, $self->routes, sub {
        return $self->dash_app;
        });

    return $self;
}

1;
