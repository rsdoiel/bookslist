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

our @EXPORT_OK = qw(
    NewBooksList::start
    NewBooksList::position
    NewBooksList::next
    NewBooksList::len
    NewBooksList::clear
    NewBooksList::parseToList
    NewBooksList::fileToList
    NewBooksList::listToString
  );

use constant EOL   => "\n";
use constant DELIM => " = ";

# Records array is where all the records get stored for booklist set.
my @records = ();
my $cursor = 0;

#
# Set the cursor position to zero.
#
sub start {
  my $pos = shift;

  if (defined($pos) && ($pos > 0)) {
      $cursor = $pos;
  } else {
      $cursor = 0;
  }
  return $cursor;
}

#
# Return the numeric value of cursor position.
#
sub position {
  return $cursor;
}

#
# Increment and return the cursor position. If
# cursor is beyond end of records array then set to zero
# and return -1.
#
sub next {
  $cursor++;
  if ($cursor >= len()) {
      $cursor = 0;
      return -1;
  }
  return $cursor;
}

#
# return the  of populated records array
#
sub len {
   return scalar(grep {defined $_} @records);
}

#
# clear the records array to an empty array.
#
sub clear {
   @records = ();
   if (len() == 0) {
     return 1;
   }
   return 0;
}

#
# return the record at the current cursor position
#
sub record {
    return $records[$cursor];
}

#
# Without affecting the cursor render the entire records
# array to a string. Should evolve this into a JSON renderer.
#
sub listToString {
    my @out  = ();
    my $rec_count = len();

    for (my $i = 0; $i < $rec_count; $i++) {
      my %item = $records[$i];
      foreach my $key ( keys %item ) {
          if ((defined $item{$key}) && ($item{$key} ne "")) {
            print "DEBUG pusing to out $key -> " . $item{$key} . EOL;
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
    my %rec     = ();
    my $recording = 0;
    my $key;
    my $value;
    my $i = 0;

    foreach my $line ( split( /\n\r|\n/, $src ) ) {
        $line =~ s/\s+$//g;
        if ( $line eq "" ) {
            if ( $recording == 1 ) {
              ## FIXME: how do I push a hash onto the end of records?
                push(@records, \%rec);
                $i++; # total record added.
                $recording = 0;
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
                        $recording = 1;
                        $rec{$key} = $combined_value;
                    } else {
                      print "DEBUG skipping substr [" . $value . "] in [" . $rec{$key} . "]". EOL;
                    }
                }
                else {
                    ## Single valued case
                    $recording = 1;
                    $rec{$key} = "$value";
                }
            }
            print "DEBUG key: $key -> " . $rec{$key} . EOL;
        }
    }
    print "DEBUG print records inside parseToList(): [" . listToString(@records) . "]" . EOL;
    print "DEBUG total records count: " . scalar(@records) . " ?= $i" . EOL;
    # return the total number of records added in this parse pass.
    return $i;
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
