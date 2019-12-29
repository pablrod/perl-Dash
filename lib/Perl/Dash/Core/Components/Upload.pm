# AUTO GENERATED FILE - DO NOT EDIT

package Perl::Dash::Core::Components::Upload;

use Perl::Dash::Core::Components;
use Mojo::Base 'Perl::Dash::BaseComponent';

has 'id';
has 'contents';
has 'filename';
has 'last_modified';
has 'children';
has 'accept';
has 'disabled';
has 'disable_click';
has 'max_size';
has 'min_size';
has 'multiple';
has 'className';
has 'className_active';
has 'className_reject';
has 'className_disabled';
has 'style';
has 'style_active';
has 'style_reject';
has 'style_disabled';
has 'loading_state';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Perl::Dash::Core::Components::_js_dist;
}

1;
