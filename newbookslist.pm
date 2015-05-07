#!/usr/bin/env perl
# newbookslist.pm - Provide some general utility methods for working with NewBooksList exported lists.
#
# @author R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institution of Technology
#
package NewBooksList;
use JSON;
use Data::Dumper;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(NewBooksList::parseToList NewBooksList::fileToList NewBooksList::listToString);

use constant EOL   => "\n";
use constant DELIM => " = ";

sub listToString {
    my @data = shift;
    my @out  = ();
print "DEBUG last index of data: " . $#data . EOL;
    while (@data) {
      my %item = shift(@data);
      foreach my $key ( keys %item ) {
          if ((defined $item{$key}) && ($item{$key} ne "")) {
            push( @out, ( "$key -> " . $item{$key} ) );
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
    my $src     = shift;
    my @records = ();
    my %rec     = ();
    my $key;
    my $value;
    my $i = 0;

    foreach my $line ( split( /\n\r|\n/, $src ) ) {
        $line =~ s/\s+$//g;
        if ( $line eq "" ) {
            if ( ( scalar keys %rec ) > 0 ) {
                $records[$i] = %rec;
                $i++;

                %rec   = ();
                $key   = "";
                $value = "";
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
            } else {
                $value = "";
            }

            ## Handle multi-valued fields as appended lines to entry.
            if ( ( $value ne "" ) && ( $key ne "" ) ) {
                ## Handle fields that are multivalued
                if ( defined $rec{$key} ) {
                    ## FIXME: Only add value is not a duplicate.
                      # DEBUG key: STANDARD # -> 9781107419247.
                      # DEBUG skipping substr [1107419247.] in [9781107419247.]
                      # DEBUG key: STANDARD # -> 9781107419247.
                      # DEBUG key: STANDARD # -> 9781107419247.
                      # 9781139208666 (ebook).

                    if (index($rec{$key}, $value) == -1) {
                        my $combined_value = $rec{$key} . EOL . "$value";
                        $rec{$key} = $combined_value;
                    } else {
                      print "DEBUG skipping substr [" . $value . "] in [" . $rec{$key} . "]". EOL;
                    }
                }
                else {
                    ## Single valued case
                    $rec{$key} = "$value";
                }
            }
            print "DEBUG key: $key -> " . $rec{$key} . EOL;
        }
    }
    print "DEBUG print records inside parseToList(): [" . listToString(@records) . "]" . EOL;
    print "DEBUG total records count: " . scalar(@records) . EOL;
    return @records;
}

#
# fileToList - read a data set exported from Millenium and convert it into an
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
    return parseToList($src);
}

1;
