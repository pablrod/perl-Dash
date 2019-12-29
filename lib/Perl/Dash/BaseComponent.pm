package Perl::Dash::BaseComponent;

use Mojo::Base -base;

sub DashNamespace {
    return 'no_namespace';
}

sub TO_JSON {
    my $self = shift;
    my @components = split(/::/, ref($self));
    my $type = $components[-1];
    my %hash = %$self;
    return { type => $type,
        namespace => $self->DashNamespace,
        props     => \%hash
        };
}

1;