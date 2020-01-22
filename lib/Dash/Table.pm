package Dash::Table;
use strict;
use warnings;
use Module::Load;

sub DataTable {
    shift @_;
    load Dash::Table::DataTable;
    if (Dash::Table::DataTable->can("children")) {
        if (((scalar @_) % 2)) {
            unshift @_, "children";
        }
    }
    return Dash::Table::DataTable->new(@_);
}
1;
