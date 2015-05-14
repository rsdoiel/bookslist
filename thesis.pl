#!/usr/bin/env perl
#############################################################################################
##### thesis.pl - Generate webpages and RSS feed of new thesis with new BooksLists module
##### 2015-05-05 RSD
#############################################################################################
use List::Util;
use BooksList;
use JSON;

use constant EOL => "\n";

# ============= BEGIN LIBRARY USER CUSTOMIZATION =====================
# DEFINE SOME VARIABLES AND SET THEIR VALUES.

# Filter by field
$filter_by = "CALL #";

# Filter by value
$filter_value = "THESIS";

# Set the path/name of the input file (the review file from III):
$inputfile = "thesis.txt";

# Set the path/name of the output file (the Web page we're creating); folders must already exist:
$outputfile = "thesis.htm";

# Want feeds to be created?
$wantfeeds = 1;    # 0 for no; 1 for yes.
                   # If no, set $feedlinks to 0 as well

# On the Web page, do you want a link to each subject's feed next to the subject?
$feedlinks = 1;    # 0 for no; 1 for yes.

# Set the path to the image that will be used for the feed link on the Web page.
# Path should be relative to where the Web page lives:
$rssimage = "rss.png";

# Set the path to the feeds directory on the LOCAL machine (where the script output will go); folders must already exist:
$localfeedsdir = "thesis\\";

# Set the full URL for where the feeds will live; do not include trailing slash:
$feedserver = "http://library.caltech.edu/techservices/new/thesisfeeds";

# Set the base URL for your Innovative server; do not include a trailing slash:
$serverbase = "http://clas.caltech.edu";

# Set the link text for the link to the catalog record; if you don't want a link, leave just the double quotes:
$catlink = "Library Catalog Record";

# Want link to catalog in new window?
$newwindow = 1;    # 0 for no; 1 for yes.

# Want the call number to show?
$displaycallno = 0;    # 0 for no; 1 for yes.

# Want the IMPRINT to display?
$displaypub = 1;       # 0 for no; 1 for yes.

# Want the LOCATION to display?
$displayloc = 1;       # 0 for no; 1 for yes.

# Want the ISBN to display?
$displayisbn = 0; # Should be zero, doesn't apply to thesis but is used in other script setups.

# Want internal nav links?
$displaynavlinks = 1;    # 0 for no; 1 for yes.

# How do you want to display them?
$navlinksform = 5;       # 1 for one column.
                         # 2 for two columns.
                         # 3 for three columns
                         # 4 for horizontal, separated by whitespace.
                         # 5 for horizontal, separated by a character.
     # If using columns, IE may require a fixed width in style sheet.

# Give the Web page a title.
$pagetitle = "Recent Thesis Additions in the Caltech Library";

# =============== END LIBRARY USER CUSTOMIZATION =====================

# Legacy container code (e.g. ebook_container.pl)
# =============== BEGIN PAGE FORMATTING ==============================
# Variables for date format:
# 	For 01 October 2007 - use $dateintl
# 	For October 1, 2007 - use $dateus
# 	For DD/MM/YYYY - use $dateddmmyyyy
# 	For MM/DD/YYYY - use $datemmddyyyy
# 	For Tue, 01 Oct 2007 20:59:43 EST - use $datelastbuild

# Name of your library:
$libname = "Caltech Library";

# Acronym for your standard time zone
$stzone = "PST";

# Acronym for your daylight savings time zone
$dszone = "PDT";

# Library -specific header. Code you use between the EOMs will start the Web page.
# You can use any of the date variables above, as well as $libname from above and $pagetitle from the main script.

sub page_header {
    my ($pagetitle, $libname, $dateintl) = @_;
    my $out = <<EOM;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <html xml:lang="en" lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>$pagetitle - $libname</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta name="Author" content="$libname" />
	<link rel="stylesheet" type="text/css" href="newacq.css" />
	</head>

	<body>
	<div id="maincontent" style="width:90%;margin:auto;background:white;color:black;">
	<div<a name="top"></a></div>

<!-- Page content starts here -->

	<h4>Thesis Additions to The Electronic Book Collections of the Caltech Library for [date]</h4>
	<p class="newacq-date">This page is updated periodically. This update: <span>$dateintl</span></p>
        <p><a href="newmaterials.htm">Books</a>
	    &nbsp;|&nbsp;<a href="journals.htm">Journals</a>
        &nbsp;|&nbsp;<a href="thesis.htm">Theses</a>
        &nbsp;|&nbsp;<a href="http://clas.caltech.edu/ftlist">What's New This Month</a>
        &nbsp;|&nbsp;<a href="http://library.caltech.edu/techservices/archives/archives.htm">Previous Months</a>
        </p>
<!-- <p>View by: <span class="newacq-sort" style="font-weight:bold;">Subject</span></p> -->

EOM

  return $out;
}

# Library-specific footer.  Code you use between the EOMs will finish the Web page.
# You can use any of the date variables above, as well as $libname from above and $pagetitle from the main script.

sub page_footer {
    my ($dateus) = @_;

    return <<EOM;
<p>&nbsp;</p>
<p>Last updated $dateus</p>
</div>
</body>
</html>

EOM

}

# Author last name navigation

sub page_author_nav {
  my @out = ();
  push @out, '<div id="newacq-navlinks">' . EOL;
  push @out, '<ul style="margin:0;padding:0;">' . EOL;
  push @out, '<li style="display:inline;white-space:nowrap;"><a name="top"> &#183;</a></li>' . EOL;

  foreach my $alpha (A..Z) {
    if (List::Util::first {$_ eq $alpha} @_) {
      push @out, '<li style="display:inline;white-space:nowrap;"><a href="#' . $alpha . '">' . $alpha . '</a> &#183;</li>';
    } else {
      push @out, '<li style="display:inline;white-space:nowrap;">'. $alpha . ' &#183;</li>';
    }
  }
  push @out, '</ul></div><!-- END id="newacq-navlinks" -->' . EOL;
  return join (" ", @out);
}
# Library-specific record markup.

sub insert_record {
  my %record = @_;
  my $author = BooksList::getAuthorsOnly(%record) || "";
  my $title  = BooksList::getTitleOnly(%record) || "";
  my $note   = $record{"NOTE"} || "";
  my $marc   = $record{"MARC"} || "";
  my $location = $record{"LOCATION"} || "";
  my $bibno = $record{"RECORD #"} || "";
  my $link = "";
  my $out = "";

  if (defined $record{"MARC"}) {
      $link = '<a href="' . $marc . '">Library Catalog Record</a>';
  } else {
      $link = '<a href="' . $serverbase . '/record=' . $bibno .
        '" target="_blank" class="newacq-catlink">Library Catalog Record</a></p>';
  }

  $out = <<EOM;
          <tr class="newacq-item">
            <td class="newacq-itemdesc">
              <p class="newacq-bib">
                <span class="newacq-author">$author</span>
                <br /><span class="newacq-title">$title</span>
                <br /><span class="newacq-pub">$note</span>
                <br /><span class="newacq-location">$location</span>
                <br />$link
              </p>
            </td>
          </tr>
EOM

  return $out;
}

# =============== END PAGE FORMATTING ================================

# ===== No need to edit this script past this point. ======

# Get today's date and prepare it for writing various ways
( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
  localtime(time);
my @monthname =
  qw( January February March April May June July August September October November December );
my @monthabbrev = qw ( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @wdayabbrev  = qw ( Sun Mon Tue Wed Thu Fri Sat );

$year = $year += 1900;

if ( $mon < 9 ) {
    $leadingmon = "0" . ( $mon + 1 );
}
else {
    $leadingmon = $mon + 1;
}

if ( $mday < 10 ) {
    $leadingmday = "0$mday";
}
else {
    $leadingmday = $mday;
}

if ( $hour < 10 ) {
    $hour = "0$hour";
}

if ( $min < 10 ) {
    $min = "0$min";
}

if ( $sec < 10 ) {
    $sec = "0$sec";
}

if ($isdst) {
    $zone = $dszone;
}
else {
    $zone = $stzone;
}

# Variable for printing date in format DD Month YYYY
# Example: 01 October 2007
$dateintl = "$leadingmday $monthname[$mon] $year";

# Variable for printing date in format Month D, YYYY
# Example: October 1, 2007
$dateus = "$monthname[$mon] $mday, $year";

# Variable for printing date in format DD/MM/YYYY
# Example: 01 October 2007 would be 01/10/2007
$dateddmmyyyy = "$leadingmday/$leadingmon/$year";

# Variable for printing date in format MM/DD/YYYY
# Example: October 1, 2007 would be 01/10/2007
$datemmddyyyy = "$leadingmon/$leadingmday/$year";

# Variable for printing lastBuildDate for feeds in format Day, DD Mon YYYY hh:mm:ss Zone
# Example: Tue, 01 Oct 2007 20:59:43 EST
$datelastbuild =
"$wdayabbrev[$wday], $leadingmday $monthabbrev[$mon] $year $hour:$min:$sec $zone";

## End of legacy Container code.

{
    my @records = BooksList::fileToList($inputfile);
    my $record_count = BooksList::recordCount(@records);
    my @out = ();
    my $alpha = "";
    my @author_nav = ();
    my $section = "";

# FIXME: Process list into HTML page.

# Build A-Z by author link to records at top

# Each entry format is Author, Title, Note, Location, Bib number (i.e. RECORD when begins with b is)

    for (my $i = 0; $i < $record_count; $i++ ) {
      my %record = %{$records[$i]};

      $author = BooksList::lastName(BooksList::getAuthorsOnly(%record));
      if (substr($author, 0, 1) ne $alpha) {
        $section = "";
        if ($alpha ne "") {
          $section .= <<EOM;
          </tr>
          </table>
          <p><a href="#top">[Return to Top]</a></p>

EOM
        }
        ## FIXME: output section heading linked to A-Z zip line.
        $alpha = substr($author, 0, 1);
        push @author_nav, $alpha;
        $section .= <<EOM;
          <h2 class="newacq-subjheading"><a name="$alpha">$alpha</a>
          <a href="$feedserver/$alpha.xml"><img src="rss.png" alt="Subscribe to the RSS feed for recent author additions with last name starting with $alpha" title="Subscribe to the RSS feed for recent additions in Astronomy" class="newacq-rssimage" /></a>
          </h2>
          <table class="newacq-itemtable">
EOM
        push @out, $section;
      }
      push @out, insert_record(%record);
    }
    if ($alpha ne "") {
      $section = <<EOM;
      </table>
      <p><a href="#top">[Return to Top]</a></p>

EOM
      push @out, $section;
    }



    print "Writing $outputfile... ";
    open (OUT, ">$outputfile") or die("Can't write to $outputfile");
    print OUT page_header($pagetitle, $libname, $dateintl);
    print OUT page_author_nav(@author_nav);
    print OUT join("\n", @out);
    print OUT page_footer($dateus);
    close(OUT);
    print " done." . EOL;

# FIXME: Process list into RSS Feed.
# FIXME: Process list into RSSJS feed.

    # Everything must have worked, return with no errors.
    exit 0;
}

# FINISHED
