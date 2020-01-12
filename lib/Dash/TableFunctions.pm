package Dash::TableFunctions;
use strict;
use warnings;
use Module::Load;
use Exporter::Auto;

sub DataTable {
    load Dash::Table::DataTable;
    return Dash::Table::DataTable->new(@_);
}
1;
