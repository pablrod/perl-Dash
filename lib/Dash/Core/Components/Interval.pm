# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Interval;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'interval';
has 'disabled';
has 'n_intervals';
has 'max_intervals';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;
