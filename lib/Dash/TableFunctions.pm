package Dash::TableFunctions;
use strict;
use warnings;
use Module::Load;
use Exporter::Auto;

sub DataTable {
    load Dash::Table::DataTable;
    if (Dash::Table::DataTable->can("children")) {
        if (((scalar @_) % 2)) {
            unshift @_, "children";
        }
    }
    return Dash::Table::DataTable->new(@_);
}
1;
