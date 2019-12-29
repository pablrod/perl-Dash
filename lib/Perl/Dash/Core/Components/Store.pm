# AUTO GENERATED FILE - DO NOT EDIT

package Perl::Dash::Core::Components::Store;

use Perl::Dash::Core::Components;
use Mojo::Base 'Perl::Dash::BaseComponent';

has 'id';
has 'storage_type';
has 'data';
has 'clear_data';
has 'modified_timestamp';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Perl::Dash::Core::Components::_js_dist;
}

1;
