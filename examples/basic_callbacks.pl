#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

use Perl::Dash;

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Perl::Dash->new(
    app_name             => 'Basic Callbacks',
    external_stylesheets => $external_stylesheets
);

$app->layout(
    {
        div => [
            {
                input =>
                  { id => 'my-id', value => 'initial value', type => 'text' }
            },
            { div => { id => 'my-div' } }
        ]
    }

    #Div([
    #        Input(id => 'my-id', value => 'initial value', type => 'text'),
    #        Div(id => 'my-div')
    #    ])
);

$app->callback(
    Output => {component_id => 'my-div', component_property => 'children'},
    Inputs => [{component_id=>'my-id', component_property=> 'value'}],
    callback => sub {
        my $input_value = shift;
        return "You've entered \"$input_value\"";
    }
);

if ( !caller() ) {
    $app->run_server();
} else {
    1;
}

