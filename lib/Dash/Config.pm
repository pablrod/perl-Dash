package Dash::Config;

use Moo;
use strictures 2;
use JSON;
use namespace::clean;

has url_base_pathname => (
    is => 'rw',
    default => sub {JSON::null}
);

has requests_pathname_prefix => (
    is => 'rw',
    default => '/'
);

has ui => (
    is => 'rw',
    default => sub {JSON::false}
);

has props_check => (
    is => 'rw',
    default => sub {JSON::false}
);

has show_undo_redo => (
    is => 'rw',
    default => sub {JSON::false}
);

sub TO_JSON {
    my $self = shift;
    my %hash = %$self;
    return \%hash;
}

1;
