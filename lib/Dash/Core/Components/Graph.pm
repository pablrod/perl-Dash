# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Graph;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'responsive';
has 'clickData';
has 'clickAnnotationData';
has 'hoverData';
has 'clear_on_unhover';
has 'selectedData';
has 'relayoutData';
has 'extendData';
has 'restyleData';
has 'figure';
has 'style';
has 'className';
has 'animate';
has 'animation_options';
has 'config';
has 'loading_state';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;
