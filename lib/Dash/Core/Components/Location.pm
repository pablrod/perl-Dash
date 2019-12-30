# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Location;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'pathname';
has 'search';
has 'hash';
has 'href';
has 'refresh';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;
