# AUTO GENERATED FILE - DO NOT EDIT

package Dash::Core::Components::Markdown;

use Dash::Core::Components;
use Mojo::Base 'Dash::BaseComponent';

has 'id';
has 'className';
has 'dangerously_allow_html';
has 'children';
has 'dedent';
has 'highlight_config';
has 'loading_state';
has 'style';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Dash::Core::Components::_js_dist;
}

1;
