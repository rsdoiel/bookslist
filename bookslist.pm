#!/usr/bin/env perl
# BooksList.pm - Provide some general utility methods for working with BooksList exported lists.
#
# @author R. S. Doiel, <rsdoiel@caltech.edu>
# copyright (c) 2015 California Institution of Technology
#
package BooksList;
use JSON;
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
  BooksList::getAuthor
  BooksList::lastName
  BooksList::lastNameFirst
);

use constant EOL   => "\n";
use constant DELIM => " = ";

=head1 BooksList

A module for working with book lists exported from various library systems.

=over

=item recordCount()

 A function that counts the records contained in a parsed books list.

 parameters: an array of records.

 return: the numeric count of populated records array

=cut

sub recordCount {
    my @in = @_;
    return scalar( grep { defined $_ } @in );
}

=item recordToString()

 Turns an individual record into a string.

 parameters: A hash representing a record.

 return: a string representation of a record.

=cut

sub recordToString {
    my %record = %{ $_[0] };
    my @out    = ();
    foreach my $key ( keys %record ) {
        push @out, "$key = " . $record{$key};
    }
    return join( "\n", @out ) . EOL . EOL;
}

=item listToString()

 Render a parsed list of records as a string.

 parameters: An array of parsed records.

 return: the list as a string.

=cut

sub listToString {
    my @in        = @_;
    my @out       = ();
    my $rec_count = scalar( grep { defined $_ } @in );

    for ( my $i = 0 ; $i < $rec_count ; $i++ ) {
        #foreach my $key ( keys $in[$i] ) {
        #    if ( ( defined $in[$i]->{$key} ) && ( $in[$i]->{$key} ne "" ) ) {
        #        push @out, ( "$key = " . $in[$i]->{$key} );
        #    }
        #}
        push @out, recordToString($in[$i]);
    }
    return join( "\n", @out );
}

=item parseToList()

 Given an entire list as a single string, parse the lines
 into a list of records.

 parameters: A string of unparsed book records like that exported from Millinium.

 return: an array of parsed records.

=cut

sub parseToList {
    my $src       = shift;
    my @records   = ();
    my %rec       = ();
    my $recording = 0;
    my $key;
    my $value;

    foreach my $line ( split( /\n\r|\n/, $src ) ) {
        $line =~ s/\s+$//g;
        if ( $line eq "" ) {
            if ( $recording == 1 ) {
                push @records, {%rec};
                $recording = 0;
                %rec       = ();
                $key       = "";
                $value     = "";
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
    }

    # return the records array
    return @records;
}

=item find()

 Given an field name find the first record with the requested value

 parameters:

  key (i.e. field name)
  value to search for
  an array of records

  return: the index position of the first matching record found or -1 if not found.

=cut

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

=item findAll()

 Build a list of record indexes for field/value pairs found.

 parameters:

  key (i.e. field name)
  value to search for
  an array of records

  return: an array of index positions of matching records, an empty array of none found.

=cut

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

=item fileAsList()

 Read a data set exported from Millenium and convert it into an
 perl array of records.  Uses the function parseToList after the lines are
 read into memory.

 parameters: the name of the file to be parsed.

 return: an array of parsed records.

=cut

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

=item toJSON()

 Convert the records array data structure into a JSON string.

 parameters: an array of records

 return: a JSON formatted string presentation of the records.

=cut

sub toJSON {
  my @in = @_;
  my $record_count = scalar( grep { defined $_ } @in );
  my @out = ();

  for (my $i = 0; $i < $record_count; $i++) {
    push @out, to_json($in[$i]);
  }
  return "[" . join(",", @out) . "]";
}

=item getAuthor()

 Look at a record and either extract the AUTHOR field or scrape author from
 TITLE field.

 parameters: the book record

 return: the author info as string in first/last order or an empty string is there is a problem.

=cut

sub getAuthor {
  my %record = @_; # %{ $_[0] };
  my $pos = 0;
  my $author = "";
  if (defined $record{"AUTHOR"}) {
    $author = $record{"AUTHOR"};
    $author =~ s/, author\.//g;
    if (index($author, ",") != -1) {
       $author = join(" ", reverse(split(", ", $author)));
       $author =~ s/\s+/ /g;
    }
  }
  if ((defined $record{"TITLE"})) {
    $pos = index($record{"TITLE"}, "/");
    if ($pos != -1) {
      $pos++;
      $author = substr $record{"TITLE"}, $pos;
    }
  }
  $author =~ s/^\s+|\s+$//g;
  return $author;
}

=item lastName()

 Get the last name from an a string generated with getAuthor().

 parameters: the string generated with getAuthor()

 return a substring of the last name.

=cut

sub lastName {
  my $raw = shift;
  my @names = split(/\s+/, $raw);
  my $last_name = pop @names;

  return $last_name;
}

=item lastNameFirst()

 Given author generated by getAuthor() re-order the string to have
 last name comma first order.

 parameters: the string generated with getAuthor()

 return a substring in last name first order.

=cut

sub lastNameFirst {
  my $raw = shift;
  my @names = split(/\s+/, $raw);
  my $last_name = pop @names;
  return $last_name . ", " . join(" ", @names);
}

=back
