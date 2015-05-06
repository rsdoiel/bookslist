#!/usr/bin/env perl
#
# Test newbookslist.pm methods.
# @author: R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institute of Technologuy
# All rights reserved
#
use NewBooksList;    # qw(parseToList fileToList listToJSON);

#
# Testing utility methods
#

sub isEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 eq $expr2 ) or die( $msg . "\n" );
}

sub isNotEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 ne $expr2 ) or die( $msg . "\n" );
}

sub isOK {
    my $expr = "" . shift;
    my $msg  = shift;
    ($expr) or die( $msg . "\n" );
}

#
# Test groupings, one group per function.
#
sub testCorrectAsserts {
    isEqual( 1, 1, "Should not fail '1' eq '1'" );
    isNotEqual( 1, 2, "Should not fail '1' ne '2'" );
    isEqual( "one", "one", "should not fail 'one' eq 'one'" );
    isNotEqual( "one", "two", "should not fail 'one' ne 'two'" );
    isNotEqual( 1,     "two", "should not fail 1 ne 'two'" );
    isOK( 1,     "Should be OK" );
    isOK( "one", "Should be OK" );
}

sub testModule {
    my $in_filename = "test-data/nbl-in-1.txt";
    my $src         = "";
    my @list0       = ();
    my @list1       = NewBooksList::fileToList($in_filename);

    open( IN, $in_filename )
      or die("Can't open test input file $in_filename\n");
    while (<IN>) {
        $src .= $_;
    }
    close(IN);
    isNotEqual( "$src", "", "Should have text of $in_filename\n" );
    @list0 = NewBooksList::parseToList($src);
    isNotEqual( scalar(@list0), 0,
        "Should have a populated list from \$src\n" );
    isNotEqual( scalar(@list1), 0,
        "Should be able to read in $in_filename and generate a list" );
    $json = listToJSON(@list0);
    isOK( $json, "Should have a string in JSON format from list0\n" );
}

#
# Run the tests we accumulate
#
print "Testing newbookslist.pm\n";
testCorrectAsserts();
testModule();
print "Success!\n";
1;
