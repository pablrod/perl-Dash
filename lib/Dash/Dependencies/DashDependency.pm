package Dash::Dependencies::DashDependency;

use Moo;
use strictures 2;
use namespace::clean;
use overload 
    '""' => "_stringify";

has component_id => (
    is => 'ro'
);

has component_property => (
    is => 'ro'
);

sub _stringify {
    my $self = shift;
    return $self->component_id . "." . $self->component_property;
}

1;
