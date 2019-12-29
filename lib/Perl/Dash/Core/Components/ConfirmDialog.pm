# AUTO GENERATED FILE - DO NOT EDIT

package Perl::Dash::Core::Components::Confirmdialog;

use Perl::Dash::Core::Components;
use Mojo::Base 'Perl::Dash::BaseComponent';

has 'id';
has 'message';
has 'submit_n_clicks';
has 'submit_n_clicks_timestamp';
has 'cancel_n_clicks';
has 'cancel_n_clicks_timestamp';
has 'displayed';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Perl::Dash::Core::Components::_js_dist;
}

1;
