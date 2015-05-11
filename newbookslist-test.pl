#!/usr/bin/env perl
#
# Test newbookslist.pm methods.
# @author: R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institute of Technologuy
# All rights reserved
#
use NewBooksList;    # qw(parseToList fileToList listToJSON);

use constant EOL => "\n";

#
# Testing utility methods
#

sub isEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 eq $expr2 ) or die("ERROR ->: " . $msg . "\n" );
}

sub isNotEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 ne $expr2 ) or die("ERROR ->: " . $msg . "\n" );
}

sub isOK {
    my $expr = "" . shift;
    my $msg  = shift;
    ($expr) or die("ERROR ->: " . $msg . "\n" );
}

sub isEmptyString {
    my $s = "" . shift;
    my $msg  = shift;
    ($s eq "") or die("ERROR ->: " . $msg . "\n" );
}

sub isNotEmptyString {
  my $s = "" . shift;
  my $msg  = shift;
  ($s ne "") or die("ERROR ->: " . $msg . "\n" );
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
    isEmptyString("", "Should be OK, an empty string");
    isNotEmptyString("Not empty", "Should be OK, not an empty string");
}

sub testFunctions {
    my $in_filename = "test-data/proof-of-concept-parser.p";
    my $src         = "";
    my $output = "";
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
    $output = NewBooksList::listToString(@list0);
    isNotEmptyString($output, "\@list0 should not produce an emprt string.");

    my $list0_cnt = NewBooksList::recordCount(@list0);
    my $list1_cnt = NewBooksList::recordCount(@list1);
    isEqual( $list0_cnt, 268,
        "Should have a populated list expected 268 got $list0_cnt");
    isEqual( $list0_cnt, $list1_cnt,
        "Should have a populated list expected 268,268 got $list0_cnt, $list1_cnt");

    my %dataset = (
      "LOCATION" => "World Wide Web",
      "STANDARD #" => "1107419247",
      );
    foreach my $key (keys %dataset) {
      my $value = $dataset{$key};
      my $row_no = NewBooksList::find($key, $value, @list0);
      isNotEqual($row_no, -1, "Should get back a row number ($row_no) for [$key] -> [$val]DEBUG");
    }

    %dataset = (
      "RECORD #" => "b15129949."
      );
    foreach my $key (keys %dataset) {
      my $value = $dataset{$key};
      my @rows = NewBooksList::findAll($key, $value, @list0);
      isEqual(scalar(@rows), 2, "Should get back two row numbers (" . join(", ", @rows) . ") for [$key] -> [$val]");
    }


    #print "Printing a list of records parsed" . EOL;
    #print $output . EOL;

    ## Some odd values for testing duplicates in fields.
      # DEBUG key: STANDARD # -> 9781107419247.
      # DEBUG skipping substr [1107419247.] in [9781107419247.]
      # DEBUG key: STANDARD # -> 9781107419247.
      # DEBUG key: STANDARD # -> 9781107419247.
      # 9781139208666 (ebook).
    ## FIXME: Need to actually validate the individual records - e.g. multi-valued fields should be generated
    ## not overwritten!
    #    $src = NewBooksList::listToString(@list0);
    #    print "DEBUG src: $src" . EOL;
}

#
# Run the tests we accumulate
#
print "Testing newbookslist.pm\n";
testCorrectAsserts();
testFunctions();
print "Success!\n";

1;
