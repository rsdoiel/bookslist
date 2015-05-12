#!/usr/bin/env perl
# BooksList.pm - Provide some general utility methods for working with BooksList exported lists.
#
# @author R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institution of Technology
#
package BooksList;
use JSON;
use Data::Dumper;
use v5.16;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(
  BooksList::recordCount
  BooksList::parseToList
  BooksList::fileToList
  BooksList::recordToString
  BooksList::listToString
  BooksList::find
  BooksList::findAll
  BooksList::toJSON
);

use constant EOL   => "\n";
use constant DELIM => " = ";

#
# return the  of populated records array
#
sub recordCount {
    my @in = @_;
    return scalar( grep { defined $_ } @in );
}

#
# recordToString - turn an individual record into a string.
#
sub recordToString {
    my %record = %{ $_[0] };
    my @out    = ();
    foreach my $key ( keys %record ) {
        push @out, "$key -> " . $record{$key};
    }
    return join( "\n", @out );
}

#
# Without affecting the cursor render the entire records
# array to a string. Should evolve this into a JSON renderer.
#
sub listToString {
    my @in        = @_;
    my @out       = ();
    my $rec_count = scalar( grep { defined $_ } @in );

    for ( my $i = 0 ; $i < $rec_count ; $i++ ) {
        foreach my $key ( keys $in[$i] ) {
            if ( ( defined $in[$i]->{$key} ) && ( $in[$i]->{$key} ne "" ) ) {
                push @out, ( "$key -> " . $in[$i]->{$key} );
            }
        }
    }
    return join( "\n", @out );
}

#
# parseToList - given an entire list as a single string, parse the lines
# into a list of records.
#
sub parseToList {
    my $src       = shift;
    my @records   = ();
    my %rec       = ();
    my $recording = 0;
    my $key;
    my $value;
    my $i = 0;

    foreach my $line ( split( /\n\r|\n/, $src ) ) {
        $line =~ s/\s+$//g;
        if ( $line eq "" ) {
            if ( $recording == 1 ) {
                push @records, {%rec};
                $recording = 0;
                %rec       = ();
                $key       = "";
                $value     = "";
                $i++;    # total record added.
            }
        }
        else {
            ## Split for key and value pair, or append line to last key.
            if ( index( $line, DELIM ) != -1 ) {
                ( $key, $value ) = split( DELIM, $line );
                $key =~ s/^\s+|\s+$//g;
            }
            else {
                $value = $line;
            }

            ## Trim the trailing spaces on the line.
            if ( defined $value ) {
                $value =~ s/\s+$//g;
            }
            else {
                $value = "";
            }
            ## Handle multi-valued fields as appended lines to entry.
            if ( ( $value ne "" ) && ( $key ne "" ) ) {
                ## Handle fields that are multivalued
                if ( defined $rec{$key} ) {
                    if ( index( $rec{$key}, $value ) == -1 ) {
                        $recording = 1;
                        my $combined_value = $rec{$key} . EOL . "$value";
                        $rec{$key} = $combined_value;
                    }
                }
                else {
                    ## Single valued case
                    $recording = 1;
                    $rec{$key} = "$value";
                }
            }
        }
    }
    if ( $recording == 1 ) {
        push @records, {%rec};
        $recording = 0;
        %rec       = ();
        $key       = "";
        $value     = "";
        $i++;    # total record added.
    }
    

    # return the records array
    return @records;
}

#
# find - given an field name find the first record with the requested value
#
sub find {
    my ( $key, $value, @in ) = @_;
    my $record_count = scalar( grep { defined $_ } @in );

    for ( my $i = 0 ; $i < $record_count ; $i++ ) {
        if (   ( defined $in[$i]{$key} )
            && ( index( $in[$i]{$key}, $value ) != -1 ) )
        {
            return $i;
        }
    }
    return -1;
}

#
# findAll - return a list of record indexes for field/value pairs found.
#
sub findAll {
    my ( $key, $value, @in ) = @_;
    my $record_count = scalar( grep { defined $_ } @in );
    my @out = ();
    for ( my $i = 0 ; $i < $record_count ; $i++ ) {
        if (   ( defined $in[$i]{$key} )
            && ( index( $in[$i]{$key}, $value ) != -1 ) )
        {
            push @out, $i;
        }
    }
    return @out;
}

#
# fileAsList - read a data set exported from Millenium and convert it into an
# perl array of records.
#
sub fileToList {
    my $in_filename = shift;
    my $src         = "";
    my @out         = ();

    open( IN, "$in_filename" ) or die "Can't open $in_filename for reading";
    while (<IN>) {
        $src .= $_;
    }
    close(IN);

    # return an array of records
    return parseToList($src);
}

#
# toJSON - convert the records array data structure into a JSON string.
#
sub toJSON {
  my @in = @_;
  my $record_count = scalar( grep { defined $_ } @in );
  my @out = ();

  for (my $i = 0; $i < $record_count; $i++) {
    push @out, to_json($in[$i]);
  }
  return "[" . join(",", @out) . "]";
}

1;
