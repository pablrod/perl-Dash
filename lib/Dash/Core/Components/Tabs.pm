# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Tabs;

use Moo;
use strictures 2;
use Dash::Core::ComponentsAssets;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'value' => (
  is => 'rw'
);
has 'className' => (
  is => 'rw'
);
has 'content_className' => (
  is => 'rw'
);
has 'parent_className' => (
  is => 'rw'
);
has 'style' => (
  is => 'rw'
);
has 'parent_style' => (
  is => 'rw'
);
has 'content_style' => (
  is => 'rw'
);
has 'vertical' => (
  is => 'rw'
);
has 'mobile_breakpoint' => (
  is => 'rw'
);
has 'children' => (
  is => 'rw'
);
has 'colors' => (
  is => 'rw'
);
has 'loading_state' => (
  is => 'rw'
);
has 'persistence' => (
  is => 'rw'
);
has 'persisted_props' => (
  is => 'rw'
);
has 'persistence_type' => (
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
