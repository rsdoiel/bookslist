#!/usr/bin/perl

# Variables for date format:
# 	For 01 October 2007 - use $dateintl
# 	For October 1, 2007 - use $dateus
# 	For DD/MM/YYYY - use $dateddmmyyyy
# 	For MM/DD/YYYY - use $datemmddyyyy
# 	For Tue, 01 Oct 2007 20:59:43 EST - use $datelastbuild

# ===== BEGIN LIBRARY CUSTOMIZATION =====

# Name of your library:
$libname = "Caltech Library";

# Acronym for your standard time zone
$stzone = "PST";

# Acronym for your daylight savings time zone
$dszone = "PDT";

# Library -specific header. Code you use between the EOMs will start the Web page.
# You can use any of the date variables above, as well as $libname from above and $pagetitle from the main script.

sub insert_header {
    print OUT <<EOM;

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
        &nbsp;|&nbsp;<a href="thesis.htm">Thesis</a>
        &nbsp;|&nbsp;<a href="http://clas.caltech.edu/ftlist">What's New This Month</a>
        &nbsp;|&nbsp;<a href="http://library.caltech.edu/techservices/archives/archives.htm">Previous Months</a>
        </p>
<!-- <p>View by: <span class="newacq-sort" style="font-weight:bold;">Subject</span></p> -->
<div id="newacq-navlinks">

EOM
}

# Library-specific footer.  Code you use between the EOMs will finish the Web page.
# You can use any of the date variables above, as well as $libname from above and $pagetitle from the main script.

sub insert_footer {
    print OUT <<EOM;
<p>&nbsp;</p>
<p>Last updated $dateus</p>
</div>
</body>
</html>

EOM
}

# ===== END LIBRARY CUSTOMIZATION =====
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
