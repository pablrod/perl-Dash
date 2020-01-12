# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Interval;

use Moo;
use strictures 2;
use Dash::Core::ComponentsAssets;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'interval' => (
  is => 'rw'
);
has 'disabled' => (
  is => 'rw'
);
has 'n_intervals' => (
  is => 'rw'
);
has 'max_intervals' => (
  is => 'rw'
);
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
    return $dash_namespace;
}
sub _js_dist {
    return Dash::Core::ComponentsAssets::_js_dist;
}

1;
