package Dash::Dependencies;

use warnings;
use strict;
use utf8;

use Dash::Dependencies::Output;
use Dash::Dependencies::Input;
use Dash::Dependencies::State;

sub Output {
    shift;
    my @params = @_;
    if (scalar @_ == 2) {
        @params = (component_id => $_[0], component_property => $_[1]);
    }
    return Dash::Dependencies::Output->new(@params);
}

sub Input {
    shift;
    my @params = @_;
    if (scalar @_ == 2) {
        @params = (component_id => $_[0], component_property => $_[1]);
    }
    return Dash::Dependencies::Input->new(@params);

}

sub State {
    shift;
    my @params = @_;
    if (scalar @_ == 2) {
        @params = (component_id => $_[0], component_property => $_[1]);
    }
    return Dash::Dependencies::State->new(@params);
}

1;
