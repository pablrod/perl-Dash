# NAME

Dash - Analytical Web Apps in Perl (Port of Plotly's Dash to Perl)

# VERSION

version 0.09

# SYNOPSIS

```perl
use Dash;
use aliased 'Dash::Html::Components' => 'html';
use aliased 'Dash::Core::Components' => 'dcc';
use aliased 'Dash::Dependencies' => 'deps';

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
    deps->Output('my-div', 'children'),
    [deps->Input('my-id', 'value')],
    sub {
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

This package is a port of [Plotly's Dash](https://dash.plot.ly/) to Perl.

Dash makes building analytical web applications very easy. No JavaScript required.

It's a great way to put a nice interactive web interface to your data analysis application 
without having to make a javascript interface and without having to setup servers or web frameworks.
The typical use case is you just have new data to your ML/AI model and you want to explore
diferent ways of training or just visualize the results of different parameter configurations.

# Basics

The main parts of a Dash App are:

- Layout

    Declarative part of the app where you specify the view. This layout is composed of components arranged in a hierarchy, just like html. 
    This components are available as component suites (for example: [Dash::Html::Components](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents), [Dash::Core::Components](https://metacpan.org/pod/Dash%3A%3ACore%3A%3AComponents), ...) 
    and they can be simple html elements (for example [Dash::Html::Components::H1](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents%3A%3AH1)) or as complex as you want like
    [Dash::Core::Components::Graph](https://metacpan.org/pod/Dash%3A%3ACore%3A%3AComponents%3A%3AGraph) that is a charting component based on [Plotly.js](https://plot.ly/javascript/).
    Most of the time you'll be using Dash Components already built and ready to use.

- Callbacks

    This is the Perl code that gets executed when some component changes 
    and the result of this execution another component (or components) gets updated.
    Every callback declares a set of inputs, a set of outputs and optionally a set of "state" inputs. 
    All inputs, outputs and "state" inputs are known as callback dependencies. Every dependency is related to 
    some property of some component, so the inputs determine that if a property of a component declared as input
    in a callback will trigger that callback, and the output returned by the callback will update the property of
    the component declared as output.

So to make a Dash app you just need to setup the layout and the callbacks. The basic skeleton will be:

```perl
my $app = Dash->new(app_name => 'My Perl Dash App'); 
$app->layout(...);
$app->callback(...);
$app->run_server();
```

In the SYNOPSIS you can get a taste of how this works and also in [the examples folder of the distribution](https://metacpan.org/release/Dash)

# Layout

The layout is the declarative part of the app and its the DOM of our app. The root element can be any component,
and after the root element is done the rest are "children" of this root component, that is they are the value of
the children property of the parent component and children can be one "thing" (text, component, whatever as long as can be converted to JSON)
or an arrayref of "things". So the components can be composed as much as you want. For example:

```perl
$app->layout(html->Div(children => [
        html->H1(children => 'Making Perl Dash Apps'),
        html->Img(src => 'https://raw.githubusercontent.com/kraih/perl-raptor/master/example.png' )
    ]));
```

## Components

This package ships the following component suites and are ready to use:

- [Dash Core Components](https://dash.plot.ly/dash-core-components) as Dash::Core::Components. Main components for interactive analytical web apps: forms and charting
- [Dash Html Components](https://dash.plot.ly/dash-html-components) as Dash::Html::Components. Basically the html elements.
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

Every component suite has a factory method for every component. And using this factory methods children keyword is optional as long as the children is the first element.
For example [Dash::Html::Components](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents) has the factory method Div to load and build a [Dash::Html::Components::Div](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents%3A%3ADiv) component:

```perl
use Dash::Html::Components;
...
$app->layout(Dash::Html::Components->Div(id => 'my-div', children => 'This is a simple div'));
# same as
$app->layout(Dash::Html::Components->Div('This is a simple div', id => 'my-div');
```

But this factory methods are meant to be aliased so this gets less verbose:

```perl
use aliased 'Dash::Html::Components' => 'html';
...
$app->layout(html->Div(id => 'my-div', children => 'This is a simple div'));
# same as
$app->layout(html->Div('This is a simple div', id => 'my-div'));
```

#### Functions

Many modules use the [Exporter](https://metacpan.org/pod/Exporter) & friends to reduce typing. If you like that way every component suite gets a Functions package to import all this functions
to your namespace. Using this functions also allows for ommiting the children keyword if the children is the first element.

So for example for [Dash::Html::Components](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponents) there is a package [Dash::Html::ComponentsFunctions](https://metacpan.org/pod/Dash%3A%3AHtml%3A%3AComponentsFunctions) with one factory function to load and build the component with the same name:

```perl
use Dash::Html::ComponentsFunctions;
...
$app->layout(Div(id => 'my-div', children => 'This is a simple div'));
# same as
$app->layout(Div('This is a simple div', id => 'my-div'));
```

# Callbacks

Callbacks are the reactive part of the web app. They listen to changes in properties of components and get fired by those changes.
The output of the callbacks can update properties for other componentes (or different properties for the same components) and
potentially firing other callbacks. So your app is "reacting" to changes. These properties that fire changes and the properties 
that get updated are dependencies of the callback, they are the "links" between components and callbacks.

Every component that is expected to fire a callback must have a unique id property.

To define a callback is necessary at least:

- Inputs

    The component property (or components properties) which fire the callback on every change. The values of this properties are inputs for the callbacks

- Output

    The component (or components) whose property (or properties) get updated

- callback

    The code that gets executed

A minimun callback will be:

```perl
$app->callback(
    Output => {component_id => 'my-div', component_property => 'children'},
    Inputs => [{component_id=>'my-id', component_property=> 'value'}],
    callback => sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

## Dependencies

Dependencies "link" components and callbacks. Every callback dependency has the following attributes:

- component\_id

    Value of the id property for the component

- component\_property

    Name of the property

### Inputs

A callback can have one or more inputs and for every input declared for a callback the value
of the property will be a parameter for the callback in the same order as the input dependencies are declared.

### Outputs

A callback can have one or more output dependencies. When there is only one
output the value returned by the callback updates the value of the property of the component.
In the second case the output of the callback has to be a list
in the list returned will be mapped one by one to the outputs in the same order as the output dependencies are declared.

### State

Apart from Inputs, a callback could need the value of other properties of other components but without 
firing the callback. State dependencies are for this case. So for every state dependency declared for a callback
the value os the property will be a parameter for the callback in the same order the state dependencies are declared
but after all inputs. 

### Dependencies using objects

Dependencies can be declared using just a hash reference but the preferred way is using the classes and factory methods and functions as with the components.

Using objects:

```perl
use Dash::Dependencies::Input;
use Dash::Dependencies::Output;
...
$app->callback(
    Output => Dash::Dependencies::Output->new(component_id => 'my-div', component_property => 'children'),
    Inputs => [Dash::Dependencies::Input->new(component_id=>'my-id', component_property=> 'value')],
    callback => sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

Using objects allows to omit the keyword arguments:

```perl
use Dash::Dependencies::Input;
use Dash::Dependencies::Output;
...
$app->callback(
    Dash::Dependencies::Output->new(component_id => 'my-div', component_property => 'children'),
    [Dash::Dependencies::Input->new(component_id=>'my-id', component_property=> 'value')],
    sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

There are also factory methods to use this dependencies, which allows to omit the keyword arguments:

```perl
use Dash::Dependencies;
...
$app->callback(
    Dash::Dependencies->Output('my-div', 'children'),
    [Dash::Dependencies->Input(component_id=>'my-id', component_property=> 'value')],
    sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

This can be aliased

```perl
use aliased 'Dash::Dependencies' => 'deps';
...
$app->callback(
    deps->Output(component_id => 'my-div', component_property => 'children'),
    [deps->Input('my-id', 'value')],
    sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

But if you prefer using just functions in you namespace:

```perl
use Dash::DependenciesFunctions;
...
$app->callback(
    Output('my-div', 'children'),
    [Input(component_id=>'my-id', component_property=> 'value')],
    sub {
        my $input_value = shift;
        return "You've entered '$input_value'";
    }
);
```

# Running App

The last step is running the app. Just call: 

```
$app->run_server();
```

And it will start a server on port 8080 and open a browser to start using your app!

# Making new components

There are [a lot of components... for Python](https://github.com/ucg8j/awesome-dash#component-libraries). So if you want to contribute I'll be glad to help.

Meanwhile you can build your own component. I'll make a better guide and an automated builder but right now you should use [https://github.com/plotly/dash-component-boilerplate](https://github.com/plotly/dash-component-boilerplate) for all the javascript part (It's [React](https://github.com/facebook/react) based) and after that the Perl part is very easy (the components are mostly javascript, or typescript):

- For every component must be a Perl class inheriting from [Dash::BaseComponent](https://metacpan.org/pod/Dash%3A%3ABaseComponent), overloading the hash dereferencing %{} with the props that the React component has (check [Dash::BaseComponent](https://metacpan.org/pod/Dash%3A%3ABaseComponent) TO\_JSON method), and with this methods:
    - DashNamespace

        Namespace of the component

    - \_js\_dist

        Javascript dependencies for the component

    - \_css\_dist

        Css dependencies for the component

Optionally the component suite will have the Functions package and the factory methods for ease of using.

Then you just have to publish the component suite as a Perl package. For new component suites you could use whatever package name you like, but if you want to use Dash:: namespace please use Dash::Components:: to avoid future collisions with further development. Besides this will make easier to find more components.

As mentioned early, I'll make an automated builder but contributions are more than welcome!! In the meantime please check [CONTRIBUTING.md](https://github.com/pablrod/perl-Dash/blob/CONTRIBUTING.md)

Making a component for Dash that is not React based is a little bit difficult so please first get the javascript part React based and after that, integrating it with Perl, R or Python will be easy.

# STATUS

At this moment this library is experimental and still under active
development and the API is going to change!

The ultimate goal of course is to support everything that the Python and R versions supports.

The use will follow the Python version of Dash, as close as possible, so the Python doc can be used with
minor changes:

- Use of -> (arrow operator) instead of .
- Main package and class for apps is Dash
- Component suites will use Perl package convention, I mean: dash\_html\_components will be Dash::Html::Components
- Instead of decorators we'll use plain old callbacks
- Callback context is available as the last parameter of the callback but without the response part
- Instead of Flask we'll be using [Mojolicious](https://metacpan.org/pod/Mojolicious) (Maybe in the future [Dancer2](https://metacpan.org/pod/Dancer2))

In the SYNOPSIS you can get a taste of how this works and also in [the examples folder of the distribution](https://metacpan.org/release/Dash) or directly in [repository](https://github.com/pablrod/perl-Dash/tree/master/examples). The full Dash tutorial is ported to Perl in those examples folder.

## Missing parts

Right now there are a lot of parts missing:

- Prefix mount
- Debug mode & hot reloading
- Dash configuration (supporting environment variables)
- Callback dependency checking
- Clientside functions
- Support for component properties data-\* and aria-\*
- Dynamic layout generation

And many more, but you could use it right now to make great apps! (If you need some inspiration... just check [https://dash-gallery.plotly.host/Portal/](https://dash-gallery.plotly.host/Portal/))

## Security

**Warning**: this module is not tested for security so test yourself if you are going to run the app server in a public facing server.

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
