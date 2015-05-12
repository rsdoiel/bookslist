#!/usr/bin/env perl
#
# Test bookslist.pm methods.
# @author: R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institute of Technologuy
# All rights reserved
#
use BooksList;
use JSON;
use constant EOL => "\n";

#
# Testing utility methods
#

sub isEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 eq $expr2 ) or die( "ERROR ->: " . $msg . "\n" );
}

sub isNotEqual {
    my $expr1 = "" . shift;
    my $expr2 = "" . shift;
    my $msg   = shift;

    ( $expr1 ne $expr2 ) or die( "ERROR ->: " . $msg . "\n" );
}

sub isOK {
    my $expr = "" . shift;
    my $msg  = shift;
    ($expr) or die( "ERROR ->: " . $msg . "\n" );
}

sub isEmptyString {
    my $s   = "" . shift;
    my $msg = shift;
    ( $s eq "" ) or die( "ERROR ->: " . $msg . "\n" );
}

sub isNotEmptyString {
    my $s   = "" . shift;
    my $msg = shift;
    ( $s ne "" ) or die( "ERROR ->: " . $msg . "\n" );
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
    isEmptyString( "", "Should be OK, an empty string" );
    isNotEmptyString( "Not empty", "Should be OK, not an empty string" );
}

sub testFunctions {
    my $in_filename = "test-data/proof-of-concept-parser.p";
    my $src         = "";
    my $output      = "";
    my @list0       = ();
    my @list1       = BooksList::fileToList($in_filename);

    open( IN, $in_filename )
      or die("Can't open test input file $in_filename\n");
    while (<IN>) {
        $src .= $_;
    }
    close(IN);

    isNotEqual( "$src", "", "Should have text of $in_filename\n" );
    @list0  = BooksList::parseToList($src);
    $output = BooksList::listToString(@list0);
    isNotEmptyString( $output, "\@list0 should not produce an emprt string." );

    my $list0_cnt = BooksList::recordCount(@list0);
    my $list1_cnt = BooksList::recordCount(@list1);
    isEqual( $list0_cnt, 269,
        "Should have a populated list expected 269 got $list0_cnt" );
    isEqual( $list0_cnt, $list1_cnt,
"Should have a populated list expected 269,269 got $list0_cnt, $list1_cnt"
    );

    my %dataset = (
        "LOCATION"   => "World Wide Web",
        "STANDARD #" => "1107419247",
    );
    foreach my $key ( keys %dataset ) {
        my $value = $dataset{$key};
        my $row_no = BooksList::find( $key, $value, @list0 );
        isNotEqual( $row_no, -1,
            "Should get back a row number ($row_no) for [$key] -> [$val]"
        );
    }

    %dataset = ( "RECORD #" => "b15129949." );
    foreach my $key ( keys %dataset ) {
        my $value = $dataset{$key};
        my @rows = BooksList::findAll( $key, $value, @list0 );
        isEqual( scalar(@rows), 2,
                "Should get back two row numbers ("
              . join( ", ", @rows )
              . ") for [$key] -> [$val]" );
    }

    my $json_src = BooksList::toJSON(@list0);
    open(my $fout, ">test.json") or die("Can't write test.json");
    print $fout $json_src;
    close($fout);

    my $json = JSON->new->utf8;

    my @list3 = @{$json->decode($json_src)};

    isNotEqual($json_src, "[]", "Should have a JSON version of \@list0");

    #print "DEBUG json: $json_src" . EOL;

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
    #    $src = BooksList::listToString(@list0);
    #    print "DEBUG src: $src" . EOL;
}

sub testThesisFeed {
  my @records = ();
  my $record_count = 0;

  @records = BooksList::fileToList("test-data/thesis.p");
  $record_count = BooksList::recordCount(@records);
  isEqual($record_count, 91, "Should find 91 thesis records in test-data/thesis.p [$record_count]");
}

#
# Run the tests we accumulate
#
print "Testing BooksList.pm\n";
testCorrectAsserts();
testFunctions();
testThesisFeed();
print "Success!\n";

1;