package Dash::BaseComponent;

use Moo;
use strictures 2;
use namespace::clean;

sub DashNamespace {
    return 'no_namespace';
}

sub TO_JSON {
    my $self = shift;
    my @components = split(/::/, ref($self));
    my $type = $components[-1];
    my %hash = %$self;
    if (!exists $hash{children}) {
        $hash{children} = undef;
    }
    return { type => $type,
        namespace => $self->DashNamespace,
        props     => \%hash
        };
}

1;
