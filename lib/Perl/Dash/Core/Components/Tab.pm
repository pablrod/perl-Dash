# AUTO GENERATED FILE - DO NOT EDIT

package Perl::Dash::Core::Components::Tab;

use Perl::Dash::Core::Components;
use Mojo::Base 'Perl::Dash::BaseComponent';

has 'id';
has 'label';
has 'children';
has 'value';
has 'disabled';
has 'disabled_style';
has 'disabled_className';
has 'className';
has 'selected_className';
has 'style';
has 'selected_style';
has 'loading_state';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Perl::Dash::Core::Components::_js_dist;
}

1;
