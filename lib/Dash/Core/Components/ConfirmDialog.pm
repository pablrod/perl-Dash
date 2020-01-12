# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::ConfirmDialog;

use Moo;
use strictures 2;
use Dash::Core::ComponentsAssets;
use namespace::clean;

extends 'Dash::BaseComponent';

has 'id' => (
  is => 'rw'
);
has 'message' => (
  is => 'rw'
);
has 'submit_n_clicks' => (
  is => 'rw'
);
has 'submit_n_clicks_timestamp' => (
  is => 'rw'
);
has 'cancel_n_clicks' => (
  is => 'rw'
);
has 'cancel_n_clicks_timestamp' => (
  is => 'rw'
);
has 'displayed' => (
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
