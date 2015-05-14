#!/usr/bin/perl
#
# Test bookslist.pm methods.
# @author: R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institute of Technologuy
# All rights reserved
#
use BooksList;
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
    my $in_filename = "test-data/proof-of-concept-parser.txt";
    my $src         = "";
    my $output      = "";
    my @list0       = ();
    my @list1       = BooksList::fileToList($in_filename);

    print "\ttestFunctions\t";
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
            "Should get back a row number ($row_no) for [$key] -> [$val]" );
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

    my $text = BooksList::recordToString( %{ $list0[2] } );

    isNotEqual( $text, "", "Should have a string for " . $list[2]{"RECORD #"} );
    print "OK" . EOL;
}

sub testThesisFeed {
    my @records      = ();
    my $record_count = 0;
    print "\ttestThesisFeed\t";
    @records      = BooksList::fileToList("test-data/thesis.txt");
    $record_count = BooksList::recordCount(@records);
    isEqual( $record_count, 91,
        "Should find 91 thesis records in test-data/thesis.txt [$record_count]"
    );
    @records      = BooksList::fileToList("test-data/2015thesis.txt");
    $record_count = BooksList::recordCount(@records);
    isEqual( $record_count, 88,
        "Should find 88 thesis records in test-data/thesis.txt [$record_count]"
    );

    print "OK" . EOL;
}

sub testAuthorsOnly {
    my %record = ();

    print "\ttestAuthorsOnly\t";

    $record{"AUTHOR"} = "Esposito, Giampiero, author. ";
    my $author = BooksList::getAuthorsOnly(%record);

    isEqual( $author, "Esposito, Giampiero", "full name: [$author]" );

    $record{"AUTHOR"} =
"Peter Chukwudi Ifeanychukwu Agbo ; Harry B. Gray, advisor ; James R. Heath, co-advisor. ";
    $author = BooksList::getAuthorsOnly(%record);
    isEqual(
        $author,
        "Peter Chukwudi Ifeanychukwu Agbo",
        "full name: [$author]"
    );

    print "OK" . EOL;
}

sub testTitleOnly {
    my %record = ();

    print "\ttestTitleOnly\t";

    $record{"TITLE"} = "This is a work / Mark Doiel, Robert Doiel";
    my $title = BooksList::getTitleOnly(%record);
    isEqual( $title, "This is a work", "Should get title only for [$title]" );

    $record{"TITLE"} =
"Analyses of planetary atmospheres across the spectrum : from titan to exoplanets / Joshua Andrew Kammer ; Yuk L. Yung, co-advisor ; Heather A. Knutson, co-advisor.";
    $title = BooksList::getTitleOnly(%record);
    isEqual(
        $title,
"Analyses of planetary atmospheres across the spectrum : from titan to exoplanets",
        "Should get title only for [$title]"
    );

    print "OK" . EOL;
}

sub testLastName {
    my $raw       = "Doiel, Robert, Scott";
    my $last_name = BooksList::lastName($raw);

    print "\ttestLastName\t";

    isEqual( $last_name, "Doiel", "$raw -> $last_name" );
    $raw       = "Robert Scott Doiel";
    $last_name = BooksList::lastName($raw);
    isEqual( $last_name, "Doiel", "$raw -> $last_name" );

    my %record = ();
    $record{"AUTHOR"} =
"Peter Chukwudi Ifeanychukwu Agbo ; Harry B. Gray, advisor ; James R. Heath, co-advisor. ";
    $raw       = BooksList::getAuthorsOnly(%record);
    $last_name = BooksList::lastName($raw);
    isEqual( $last_name, "Agbo", "$raw -> $last_name" );

    print "OK" . EOL;
}

#
# Run the tests we accumulate
#
print "Testing BooksList.pm\n";
testCorrectAsserts();
testFunctions();
testThesisFeed();
testAuthorsOnly();
testTitleOnly();
testLastName();
print "Success!\n";

