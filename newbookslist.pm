#!/usr/bin/env perl
# newbookslist.pm - Provide some general utility methods for working with NewBooksList exported lists.
#
# @author R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institution of Technology
#
package NewBooksList;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(NewBooksList::parseToList NewBooksList::fileToList NewBooksList::listToJSON);

#
# parseToList - given an entire list as a single string, parse the lines
# into a list of records.
#
sub parseToList {
    my $src     = shift;
    my @records = ();
    print "WARNING: parseToList() not implemented.\n";
    return @records;
}

#
# fileToList - read a data set exported from Millenium and convert it into an
# perl array of records.
#
sub fileToList {
    my $in_filename = shift;
    my $src         = "";

    open( IN, "$in_filename" ) or die "Can't open $in_filename for reading";
    while (<IN>) {
        $src .= $_;
    }
    close(IN);
    return parseToList($src);
}

#
# listToJSON - stream in an input file and generate a valid JSON file
#
sub listToJSON {
    my @list = shift;
    my $json = "";

    print "WARNING: listToJSON() not implemented.\n";
    return $json;
}

1;
