# NAME

Dash - Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

# VERSION

version 0.02

# SYNOPSIS

```perl
use Dash;
use aliased 'Dash::Html::Components::Div';
use aliased 'Dash::Html::Components::H1';
use aliased 'Dash::Core::Components::Input';

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Dash->new(
    app_name             => 'Basic Callbacks',
    external_stylesheets => $external_stylesheets
);

$app->layout(
    Div->new(children => [
        H1->new(children => 'Titulo'),
        Input->new(id => 'my-id', value => 'initial value', type => 'text'),
        Div->new(id => 'my-div')
    ])
);

$app->callback(
    Output => {component_id => 'my-div', component_property => 'children'},
    Inputs => [{component_id=>'my-id', component_property=> 'value'}],
    callback => sub {
        my $input_value = shift;
        return "You've entered \"$input_value\"";
    }
);

$app->run_server();

use Dash;
use aliased 'Dash::Html::Components::Div';
use aliased 'Dash::Core::Components::Input';
use aliased 'Dash::Core::Components::Graph';

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Dash->new(
    app_name             => 'Basic Callbacks',
    external_stylesheets => $external_stylesheets
);

my $initial_number_of_values = 20;
$app->layout(
    Div->new(children => [
        Input->new(id => 'my-id', value => $initial_number_of_values, type => 'number'),
        Graph->new(id => 'my-graph')
    ])
);

my $serie = [ map { rand(100) } 1 .. $initial_number_of_values];
$app->callback(
    Output => {component_id => 'my-graph', component_property => 'figure'},
    Inputs => [{component_id=>'my-id', component_property=> 'value'}],
    callback => sub {
        my $number_of_elements = shift;
        my $size_of_serie = scalar @$serie;
        if ($number_of_elements >= $size_of_serie) {
            push @$serie, map { rand(100) } $size_of_serie .. $number_of_elements;
        } else {
            @$serie = @$serie[0 .. $number_of_elements];
        }
        return { data => [ {
            type => "scatter",
            y => $serie
            }]};
    }
);

$app->run_server();
```

# DESCRIPTION

This package is a port of [Plotly's Dash](https://dash.plot.ly/) to Perl. As
the official Dash doc says: _Dash is a productive Python framework for building web applications_. 
So this Perl package is a humble atempt to ease the task of building data visualization web apps in Perl.

The ultimate goal of course is to support everything that the Python version supports.

The use will follow, as close as possible, the Python version of Dash so the Python doc can be used with
minor changes:

- Use of -> (arrow operator) instead of .
- Main package and class for apps is Dash
- Component suites will use Perl package convention, I mean: dash\_html\_components will be Dash::Html::Components, although for new component suites you could use whatever package name you like
- Instead of decorators we'll use plain old callbacks
- Instead of Flask we'll be using [Mojolicious](https://metacpan.org/pod/Mojolicious) (Maybe in the future [Dancer2](https://metacpan.org/pod/Dancer2))

In the SYNOPSIS you can get a taste of how this works and also in [the examples folder of the distribution](https://metacpan.org/release/Dash) or directly in [repository](https://github.com/pablrod/perl-Dash/tree/master/examples)

# STATUS

At this moment this library is experimental and still under active
development and the API is going to change!

The intent of this release is to try, test and learn how to improve it.

If you want to help, just get in contact! Every contribution is welcome!

# DISCLAIMER

This is an unofficial Plotly Perl module. Currently I'm not affiliated in any way with Plotly. 
But I think Dash is a great library and I want to use it with perl.

If you like Dash please consider supporting them purchasing professional services: [Dash Enterprise](https://plot.ly/dash/)

# SEE ALSO

[Dash](https://dash.plot.ly/)
[Dash Repository](https://github.com/plotly/dash)
[Chart::Plotly](https://metacpan.org/pod/Chart%3A%3APlotly)
[Chart::GGPlot](https://metacpan.org/pod/Chart%3A%3AGGPlot)
[Alt::Data::Frame::ButMore](https://metacpan.org/pod/Alt%3A%3AData%3A%3AFrame%3A%3AButMore)

# AUTHOR

Pablo Rodríguez González <pablo.rodriguez.gonzalez@gmail.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2019 by Pablo Rodríguez González.

This is free software, licensed under:

```
The MIT (X11) License
```
