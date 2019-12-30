package Dash::Renderer;

use strict;
use warnings;

use JSON;
use File::ShareDir;
use Path::Tiny;

my $_deps; 

sub _deps {
    my $kind = shift;
    if (!defined $_deps) {
        # TODO recover from __PACKAGE__ variable
        $_deps = from_json(Path::Tiny::path(File::ShareDir::dist_file('Dash', Path::Tiny::path('assets', 'dash_renderer', 'js_deps.json' )->canonpath ))->slurp_utf8);
    }
    if (defined $kind) {
        return $_deps->{$kind};
    } 
    return $_deps;
}

sub _js_dist {
    return _deps('_js_dist');
}

sub _css_dist {
    return _deps('_css_dist');
}

sub _js_dist_dependencies {
    return _deps('_js_dist_dependencies');
}
 
1;
 

