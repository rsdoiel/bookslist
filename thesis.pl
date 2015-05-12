#!/usr/bin/env perl
#############################################################################################
##### thesis.pl - Generate webpages and RSS feed of new thesis with BooksLists module
##### 2015-05-05 RSD
#############################################################################################

# ===== BEGIN LIBRARY CUSTOMIZATION =====

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
$displayisbn = 0;

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

# ===== END LIBRARY CUSTOMIZATION =====

use BooksList;
use JSON;

#
# Global objects for program
#
my @records = ();


# Get the code for your library-specific header/footer as well as dates:
require "thesis_container.pl";

# ===== No need to edit this script past this point...unless you know what you're doing. ======
{

    my @records = BooksList::fileToList($inputfile);

# FIXME: Process list into HTML page.
# FIXME: Process list into RSS Feed.
# FIXME: Process list into RSSJS feed.

    # Everything must have worked, return with no errors.
    exit 0;
}

# FINISHED
