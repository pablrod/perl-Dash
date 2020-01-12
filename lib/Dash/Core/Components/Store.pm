# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Store;

use Moo;
use strictures 2;
use Dash::Core::ComponentsAssets;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'storage_type' => (
  is => 'rw'
);
has 'data' => (
  is => 'rw'
);
has 'clear_data' => (
  is => 'rw'
);
has 'modified_timestamp' => (
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
