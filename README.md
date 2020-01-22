# NAME

Dash - Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

# VERSION

version 0.08

# SYNOPSIS

```perl
use Dash;
use aliased 'Dash::Html::Components' => 'html';
use aliased 'Dash::Core::Components' => 'dcc';

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Dash->new(
    app_name             => 'Basic Callbacks',
    external_stylesheets => $external_stylesheets
);

$app->layout(
    html->Div([
        dcc->Input(id => 'my-id', value => 'initial value', type => 'text'),
        html->Div(id => 'my-div')
    ])
);

$app->callback(
    Output => {component_id => 'my-div', component_property => 'children'},
    Inputs => [{component_id=>'my-id', component_property=> 'value'}],
    callback => sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);

$app->run_server();

use Dash;
use aliased 'Dash::Html::Components' => 'html';
use aliased 'Dash::Core::Components' => 'dcc';

my $external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css'];

my $app = Dash->new(
    app_name             => 'Random chart',
    external_stylesheets => $external_stylesheets
);

my $initial_number_of_values = 20;
$app->layout(
    html->Div(children => [
        dcc->Input(id => 'my-id', value => $initial_number_of_values, type => 'number'),
        dcc->Graph(id => 'my-graph')
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

In the SYNOPSIS you can get a taste of how this works and also in [the examples folder of the distribution](https://metacpan.org/release/Dash) or directly in [repository](https://github.com/pablrod/perl-Dash/tree/master/examples). The full Dash tutorial is ported to Perl in those examples folder.

## Components

This package ships the following component suites and are ready to use:

- [Dash Core Components](https://dash.plot.ly/dash-core-components) as Dash::Core::Components
- [Dash Html Components](https://dash.plot.ly/dash-html-components) as Dash::Html::Components
- [Dash DataTable](https://dash.plot.ly/datatable) as Dash::Table

The plan is to make the packages also for [Dash-Bio](https://dash.plot.ly/dash-bio), [Dash-DAQ](https://dash.plot.ly/dash-daq), [Dash-Canvas](https://dash.plot.ly/canvas) and [Dash-Cytoscape](https://dash.plot.ly/cytoscape).

### Using the components

Every component has a class of its own. For example dash-html-component Div has the class: [Dash::Html::Components::Div](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents%3A%3ADiv) and you can use it the perl standard way:

```perl
use Dash::Html::Components::Div;
...
$app->layout(Dash::Html::Components::Div->new(id => 'my-div', children => 'This is a simple div'));
```

But with every component suite could be a lot of components. So to ease the task of importing them (one by one is a little bit tedious) we could use two ways:

#### Factory methods

Every component suite has a factory method for every component. For example [Dash::Html::Components](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents) has the factory method Div to load and build a [Dash::Html::Components::Div](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents%3A%3ADiv) component:

```perl
use Dash::Html::Components;
...
$app->layout(Dash::Html::Components->Div(id => 'my-div', children => 'This is a simple div'));
```

But this factory methods are meant to be aliased so this gets less verbose:

```perl
use aliased 'Dash::Html::Components' => 'html';
...
$app->layout(html->Div(id => 'my-div', children => 'This is a simple div'));
```

#### Functions

Many modules use the [Exporter](https://metacpan.org/pod/Exporter) & friends to reduce typing. If you like that way every component suite gets a Functions package to import all this functions
to your namespace.

So for example for [Dash::Html::Components](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents) there is a package [Dash::Html::ComponentsFunctions](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponentsFunctions) with one factory function to load and build the component with the same name:

```perl
use Dash::Html::ComponentsFunctions;
...
$app->layout(Div(id => 'my-div', children => 'This is a simple div'));
```

### I want more components

There are [a lot of components... for Python](https://github.com/ucg8j/awesome-dash#component-libraries). So if you want to contribute I'll be glad to help.

Meanwhile you can build your own component. I'll make a better guide and an automated builder but right now you should use [https://github.com/plotly/dash-component-boilerplate](https://github.com/plotly/dash-component-boilerplate) for all the javascript part (It's [React](https://github.com/facebook/react) based) and after that the Perl part is very easy (the components are mostly javascript, or typescript):

- For every component must be a Perl class inheriting from [Dash::BaseComponent](https://metacpan.org/pod/Dash%3A%3ABaseComponent), overloaded the hash dereferencing %{} with the props that the React component has, and with this methods:
    - DashNamespace

        Namespace of the component

    - \_js\_dist

        Javascript dependencies for the component

    - \_css\_dist

        Css dependencies for the component

Optionally the component suite will have the Functions package and the factory methods for ease of using.

As mentioned early, I'll make an automated builder but contributions are more than welcome!!

Making a component for Dash that is not React based is a little bit difficult so please first get the javascript part React based and integrating it with Perl, R or Python will be easy.

# Missing parts

Right now there are a lot of parts missing:

- Callback context
- Prefix mount
- Debug mode & hot reloading
- Dash configuration (supporting environment variables)
- Callback dependency checking
- Clientside functions
- Support for component properties data-\* and aria-\*
- Dynamic layout generation

And many more, but you could use it right now to make great apps! (If you need some inspiration... just check [https://dash-gallery.plotly.host/Portal/](https://dash-gallery.plotly.host/Portal/))

# STATUS

At this moment this library is experimental and still under active
development and the API is going to change!

The intent of this release is to try, test and learn how to improve it.

Security warning: this module is not tested for security so test yourself if you are going to run the app server in a public facing server.

If you want to help, just get in contact! Every contribution is welcome!

# DISCLAIMER

This is an unofficial Plotly Perl module. Currently I'm not affiliated in any way with Plotly. 
But I think Dash is a great library and I want to use it with perl.

If you like Dash please consider supporting them purchasing professional services: [Dash Enterprise](https://plot.ly/dash/)

# SEE ALSO

- [Dash](https://dash.plot.ly/)
- [Dash Repository](https://github.com/plotly/dash)
- [Chart::Plotly](https://metacpan.org/pod/Chart%3A%3APlotly)
- [Chart::GGPlot](https://metacpan.org/pod/Chart%3A%3AGGPlot)
- [Alt::Data::Frame::ButMore](https://metacpan.org/pod/Alt%3A%3AData%3A%3AFrame%3A%3AButMore)
- [AI::MXNet](https://metacpan.org/pod/AI%3A%3AMXNet)

# AUTHOR

Pablo Rodríguez González <pablo.rodriguez.gonzalez@gmail.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2020 by Pablo Rodríguez González.

This is free software, licensed under:

```
The MIT (X11) License
```
