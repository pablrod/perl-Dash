# AUTO GENERATED FILE - DO NOT EDIT

package Perl::Dash::Core::Components::Datepickerrange;

use Perl::Dash::Core::Components;
use Mojo::Base 'Perl::Dash::BaseComponent';

has 'id';
has 'start_date';
has 'start_date_id';
has 'end_date_id';
has 'end_date';
has 'min_date_allowed';
has 'max_date_allowed';
has 'initial_visible_month';
has 'start_date_placeholder_text';
has 'end_date_placeholder_text';
has 'day_size';
has 'calendar_orientation';
has 'is_RTL';
has 'reopen_calendar_on_clear';
has 'number_of_months_shown';
has 'with_portal';
has 'with_full_screen_portal';
has 'first_day_of_week';
has 'minimum_nights';
has 'stay_open_on_select';
has 'show_outside_days';
has 'month_format';
has 'display_format';
has 'disabled';
has 'clearable';
has 'style';
has 'className';
has 'updatemode';
has 'loading_state';
has 'persistence';
has 'persisted_props';
has 'persistence_type';
my $dash_namespace = 'dash_core_components';

sub DashNamespace {
return $dash_namespace;
}
sub _js_dist {
return Perl::Dash::Core::Components::_js_dist;
}

1;
