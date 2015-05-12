#!/usr/bin/env perl
#
# calltosubject.pm - functions for mapping call numbers to subjects.
#
# based on legacy call2subject.pl.
#
package CallToSubject;
use JSON;
use v5.16;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(
  CallToSubject::special_callnos
  CallToSubject::dewey_2_subj_lc_match
  CallToSubject::dewey_2_subj_midrange
  CallToSubject::dewey_2_subj_detailed
  CallToSubject::dewey_2_subj_firstsum
  CallToSubject::lc_2_subj
);

use constant EOL   => "\n";

=head1 Subject

  A set of functions for mapping call numbers to subject headings.

=cut

=item special_callnos()

  In your perl script used when $specialcall = 1

  parameters: call number value(s)

  return: subject line or empty string.

=cut

sub special_callnos {
    die("CallToSubject::special_callnos() not implemented.");
}

sub dewey_2_subj_lc_match {
    die("CallToSubject::dewey_2_subj_lc_match() not implemented.");
}

sub dewey_2_subj_midrange {
    die("CallToSubject::dewey_2_subj_midrange() not implemented.");
}

sub dewey_2_subj_detailed {
    die("CallToSubject::dewey_2_subj_detailed() not implemented.");
}

sub dewey_2_subj_firstsum {
    die("CallToSubject::dewey_2_subj_firstsum() not implemented.");
}

sub lc_2_subj {
    die("CallToSubject::lc_2_subj() not implemented.");
}

__END__;


## FIXME: convert the functions below into module methods working in individual
## records or list of records as appropriate.

sub special_callnos {

    # Activated if $specialcall = 1
    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    # Deal with non-DDC and non-LC call numbers
    s/\n\nCALL # = JOURNAL ISSUE.*\n/SUBJECT = SPECIAL JOURNAL ISSUES/g;
    s/\n\nCALL # = JOURNAL.*\n/SUBJECT = JOURNALS/g;
    s/\n\nCALL # = SHELF.*\n/SUBJECT = TECHNICAL REPORTS/g;
    s/\n\nCALL # = THESIS.*\n/SUBJECT = THESES/g;
    s/\n\nCALL # = ONLINE.*\n/SUBJECT = WWW RESOURCES/g;
    s/\n\nCALL # = ASCIT movie.*\n/SUBJECT = ASCIT MOVIE/g;

    return $_;
}

sub dewey_2_subj_lc_match {

    # Activated if $ddclevel = 4
    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    s/\n\nCALL # = 00[12].+\n/SUBJECT = General Works/g;
    s/\n\nCALL # = 00[3-6].+\n/SUBJECT = Computer Science/g;
    s/\n\nCALL # = 0[1-9].+\n/SUBJECT = General Works/g;

    s/\n\nCALL # = 1[^35].+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = 1[35].+\n/SUBJECT = Psychology/g;

    s/\n\nCALL # = 2.+\n/SUBJECT = Religion/g;
    s/\n\nCALL # = 300.+\n/SUBJECT = Sociology/g;
    s/\n\nCALL # = 30[1-9].+\n/SUBJECT = Sociology/g;
    s/\n\nCALL # = 31.+\n/SUBJECT = Political Science/g;
    s/\n\nCALL # = 32.+\n/SUBJECT = Political Science/g;
    s/\n\nCALL # = 33.+\n/SUBJECT = Economics and Business/g;
    s/\n\nCALL # = 34.+\n/SUBJECT = Law/g;
    s/\n\nCALL # = 35[0-4].+\n/SUBJECT = Economics and Business/g;
    s/\n\nCALL # = 35[5-9].+\n/SUBJECT = Military Science/g;
    s/\n\nCALL # = 36.+\n/SUBJECT = Sociology/g;
    s/\n\nCALL # = 37.+\n/SUBJECT = Education/g;
    s/\n\nCALL # = 38.+\n/SUBJECT = Economics and Business/g;
    s/\n\nCALL # = 39.+\n/SUBJECT = Anthropology/g;

    s/\n\nCALL # = 4.+\n/SUBJECT = Language and Literature/g;

    s/\n\nCALL # = 50.+\n/SUBJECT = Science - General/g;
    s/\n\nCALL # = 51.+\n/SUBJECT = Mathematics/g;
    s/\n\nCALL # = 5[23].+\n/SUBJECT = Physics/g;
    s/\n\nCALL # = 54.+\n/SUBJECT = Chemistry/g;
    s/\n\nCALL # = 55.+\n/SUBJECT = Geology and Environmental Science/g;
    s/\n\nCALL # = 5[6-9].+\n/SUBJECT = Biology/g;

    s/\n\nCALL # = 60.+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = 61.+\n/SUBJECT = Medicine/g;
    s/\n\nCALL # = 62.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 63.+\n/SUBJECT = Agriculture/g;
    s/\n\nCALL # = 64.+\n/SUBJECT = Home and Family Management/g;
    s/\n\nCALL # = 65.+\n/SUBJECT = Economics and Business/g;
    s/\n\nCALL # = 66.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 6[789].+\n/SUBJECT = Economics and Business/g;

    s/\n\nCALL # = 70.+\n/SUBJECT = Arts - General/g;
    s/\n\nCALL # = 7[12].+\n/SUBJECT = Art/g;
    s/\n\nCALL # = 7[3-7].+\n/SUBJECT = Art/g;
    s/\n\nCALL # = 78.+\n/SUBJECT = Music/g;
    s/\n\nCALL # = 79.+\n/SUBJECT = Recreation and Leisure/g;

    s/\n\nCALL # = 8.+\n/SUBJECT = Language and Literature/g;

    s/\n\nCALL # = 9[0-2].+\n/SUBJECT = History - Biography, etc\./g;
    s/\n\nCALL # = 9[3-6].+\n/SUBJECT = History - World/g;
    s/\n\nCALL # = 9[78].+\n/SUBJECT = History - Americas/g;
    s/\n\nCALL # = 99.+\n/SUBJECT = History - World/g;
}

sub dewey_2_subj_midrange {

    # Activated if $ddclevel = 2
    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    s/\n\nCALL # = 00[12].+\n/SUBJECT = Knowledge and General Works/g;
    s/\n\nCALL # = 00[3-6].+\n/SUBJECT = Computer Science/g;
    s/\n\nCALL # = 0[1-9].+\n/SUBJECT = Knowledge and General Works/g;

    s/\n\nCALL # = 1[^35].+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = 1[35].+\n/SUBJECT = Psychology/g;

    s/\n\nCALL # = 2.+\n/SUBJECT = Religion/g;
    s/\n\nCALL # = 300.+\n/SUBJECT = Social Sciences - General/g;
    s/\n\nCALL # = 30[1-9].+\n/SUBJECT = Sociology and Anthropology/g;
    s/\n\nCALL # = 31.+\n/SUBJECT = Statistics/g;
    s/\n\nCALL # = 32.+\n/SUBJECT = Political Science/g;
    s/\n\nCALL # = 33.+\n/SUBJECT = Economics/g;
    s/\n\nCALL # = 34.+\n/SUBJECT = Law/g;
    s/\n\nCALL # = 35[0-4].+\n/SUBJECT = Public Administration/g;
    s/\n\nCALL # = 35[5-9].+\n/SUBJECT = Military Science/g;
    s/\n\nCALL # = 36.+\n/SUBJECT = Sociology/g;
    s/\n\nCALL # = 37.+\n/SUBJECT = Education/g;
s/\n\nCALL # = 38.+\n/SUBJECT = Commerce, Communications, and Transportation/g;
    s/\n\nCALL # = 39.+\n/SUBJECT = Customs, Etiquette, and Folklore/g;

    s/\n\nCALL # = 4.+\n/SUBJECT = Language/g;

    s/\n\nCALL # = 50.+\n/SUBJECT = Science - General/g;
    s/\n\nCALL # = 51.+\n/SUBJECT = Mathematics/g;
    s/\n\nCALL # = 5[23].+\n/SUBJECT = Astronomy and Physics/g;
    s/\n\nCALL # = 54.+\n/SUBJECT = Chemistry/g;
    s/\n\nCALL # = 55.+\n/SUBJECT = Earth Sciences/g;
    s/\n\nCALL # = 5[6-9].+\n/SUBJECT = Life Sciences/g;

    s/\n\nCALL # = 60.+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = 61.+\n/SUBJECT = Medicine/g;
    s/\n\nCALL # = 62.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 63.+\n/SUBJECT = Agriculture/g;
    s/\n\nCALL # = 64.+\n/SUBJECT = Home and Family Management/g;
    s/\n\nCALL # = 65.+\n/SUBJECT = Management/g;
    s/\n\nCALL # = 66.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 6[789].+\n/SUBJECT = Manufacturing and Construction/g;

    s/\n\nCALL # = 70.+\n/SUBJECT = Arts - General/g;
    s/\n\nCALL # = 7[12].+\n/SUBJECT = Architecture and Landscaping/g;
    s/\n\nCALL # = 7[3-7].+\n/SUBJECT = Arts - Visual/g;
    s/\n\nCALL # = 78.+\n/SUBJECT = Arts - Music/g;
    s/\n\nCALL # = 79.+\n/SUBJECT = Arts - Performing, and Recreation/g;

    s/\n\nCALL # = 80.+\n/SUBJECT = Literature - General/g;
    s/\n\nCALL # = 8[12].+\n/SUBJECT = Literature - English Language/g;
    s/\n\nCALL # = 8[3-9].+\n/SUBJECT = Literature - Non-English/g;

    s/\n\nCALL # = 90.+\n/SUBJECT = History/g;
    s/\n\nCALL # = 91.+\n/SUBJECT = Geography and Travel/g;
    s/\n\nCALL # = 92.+\n/SUBJECT = Biography and Genealogy/g;
    s/\n\nCALL # = 9[3-9].+\n/SUBJECT = History/g;
}

sub dewey_2_subj_detailed {

    # Activated if $ddclevel = 3
    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    s/\n\nCALL # = 00[12].+\n/SUBJECT = Knowledge and Books/g;
    s/\n\nCALL # = 00[3-6].+\n/SUBJECT = Computer Science/g;
    s/\n\nCALL # = 01.+\n/SUBJECT = Bibliography/g;
    s/\n\nCALL # = 02.+\n/SUBJECT = Library and Information Sciences/g;
    s/\n\nCALL # = 0[3-8].+\n/SUBJECT = General Works/g;
    s/\n\nCALL # = 09.+\n/SUBJECT = Knowledge and Books/g;
    s/\n\nCALL # = 1[^35].+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = 1[35].+\n/SUBJECT = Psychology/g;
    s/\n\nCALL # = 2.+\n/SUBJECT = Religion/g;
    s/\n\nCALL # = 300.+\n/SUBJECT = Social Sciences - General/g;
    s/\n\nCALL # = 30[1-9].+\n/SUBJECT = Sociology and Anthropology/g;
    s/\n\nCALL # = 31.+\n/SUBJECT = Statistics/g;
    s/\n\nCALL # = 32.+\n/SUBJECT = Political Science/g;
    s/\n\nCALL # = 33.+\n/SUBJECT = Economics/g;
    s/\n\nCALL # = 34.+\n/SUBJECT = Law/g;
    s/\n\nCALL # = 35[0-4].+\n/SUBJECT = Public Administration/g;
    s/\n\nCALL # = 35[5-9].+\n/SUBJECT = Military Science/g;
    s/\n\nCALL # = 36.+\n/SUBJECT = Social Problems and Services/g;
    s/\n\nCALL # = 37.+\n/SUBJECT = Education/g;
s/\n\nCALL # = 38.+\n/SUBJECT = Commerce, Communications, and Transportation/g;
    s/\n\nCALL # = 39.+\n/SUBJECT = Customs, Etiquette, and Folklore/g;
    s/\n\nCALL # = 4.+\n/SUBJECT = Language/g;
    s/\n\nCALL # = 50.+\n/SUBJECT = Science - General/g;
    s/\n\nCALL # = 51.+\n/SUBJECT = Mathematics/g;
    s/\n\nCALL # = 52.+\n/SUBJECT = Astronomy/g;
    s/\n\nCALL # = 53.+\n/SUBJECT = Physics/g;
    s/\n\nCALL # = 54.+\n/SUBJECT = Chemistry/g;
    s/\n\nCALL # = 55.+\n/SUBJECT = Earth Sciences/g;
    s/\n\nCALL # = 56.+\n/SUBJECT = Paleontology/g;
    s/\n\nCALL # = 57.+\n/SUBJECT = Biology/g;
    s/\n\nCALL # = 58.+\n/SUBJECT = Botany/g;
    s/\n\nCALL # = 59.+\n/SUBJECT = Zoology/g;
    s/\n\nCALL # = 60.+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = 61.+\n/SUBJECT = Medicine and Health/g;
    s/\n\nCALL # = 62.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 63.+\n/SUBJECT = Agriculture/g;
    s/\n\nCALL # = 64.+\n/SUBJECT = Home and Family Management/g;
    s/\n\nCALL # = 65.+\n/SUBJECT = Management/g;
    s/\n\nCALL # = 66.+\n/SUBJECT = Engineering/g;
    s/\n\nCALL # = 6[78].+\n/SUBJECT = Manufacturing/g;
    s/\n\nCALL # = 69.+\n/SUBJECT = Construction/g;
    s/\n\nCALL # = 70.+\n/SUBJECT = Arts - General/g;
    s/\n\nCALL # = 7[12].+\n/SUBJECT = Architecture and Landscaping/g;
    s/\n\nCALL # = 7[3-7].+\n/SUBJECT = Arts - Visual/g;
    s/\n\nCALL # = 78.+\n/SUBJECT = Music/g;
    s/\n\nCALL # = 79.+\n/SUBJECT = Recreation and Performing Arts/g;
    s/\n\nCALL # = 80.+\n/SUBJECT = Literature - General/g;
    s/\n\nCALL # = 8[12].+\n/SUBJECT = Literature - English Language/g;
    s/\n\nCALL # = 8[3-9].+\n/SUBJECT = Literature - Non-English/g;
    s/\n\nCALL # = 90.+\n/SUBJECT = History - General and World/g;
    s/\n\nCALL # = 91.+\n/SUBJECT = Geography and Travel/g;
    s/\n\nCALL # = 92.+\n/SUBJECT = Biography and Genealogy/g;
    s/\n\nCALL # = 93.+\n/SUBJECT = History - Ancient/g;
    s/\n\nCALL # = 94.+\n/SUBJECT = History - Europe/g;
    s/\n\nCALL # = 95.+\n/SUBJECT = History - Asia/g;
    s/\n\nCALL # = 96.+\n/SUBJECT = History - Africa/g;
    s/\n\nCALL # = 97.+\n/SUBJECT = History - North America/g;
    s/\n\nCALL # = 98.+\n/SUBJECT = History - South America/g;
    s/\n\nCALL # = 99.+\n/SUBJECT = History - Other Areas/g;
}

sub dewey_2_subj_firstsum {

    # Activated if $ddclevel = 1
    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    s/\n\nCALL # = 00[3-6].+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = 0[12789].+\n/SUBJECT = General Works/g;
    s/\n\nCALL # = 1.+\n/SUBJECT = Philosophy and Psychology/g;
    s/\n\nCALL # = 2.+\n/SUBJECT = Religion/g;
    s/\n\nCALL # = 3.+\n/SUBJECT = Social Sciences/g;
    s/\n\nCALL # = 4.+\n/SUBJECT = Language/g;
    s/\n\nCALL # = 5.+\n/SUBJECT = Science/g;
    s/\n\nCALL # = 6.+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = 7.+\n/SUBJECT = Arts and Recreation/g;
    s/\n\nCALL # = 8.+\n/SUBJECT = Literature/g;
    s/\n\nCALL # = 9.+\n/SUBJECT = History and Geography/g;
}

sub lc_2_subj {

# Convert "CALL # = call number" into "SUBJECT = LC subject".
# This depends on their being two line breaks before each record.
# A line feed is not included after the LC subject because it leads to unwanted spaces in anchors.

    # First get rid of any extra call numbers on next lines:
    s/(\n\nCALL # = .+\n)CALL # = .+\n/$1/;
    s/(\nCALL # = .+\n)CALL # = .+\n/$1/;

    # Then start converting;
    s/\n\nCALL # = A.+\n/SUBJECT = General Works/g;
    s/\n\nCALL # = BC.+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = BD.+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = BF.+\n/SUBJECT = Psychology/g;
    s/\n\nCALL # = BH.+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = BJ.+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = B[L-Z].+\n/SUBJECT = Religion/g;
    s/\n\nCALL # = B.+\n/SUBJECT = Philosophy/g;
    s/\n\nCALL # = C.+\n/SUBJECT = History - Related/g;
    s/\n\nCALL # = D.+\n/SUBJECT = History - World/g;
    s/\n\nCALL # = E.+\n/SUBJECT = History - Americas/g;
    s/\n\nCALL # = F.+\n/SUBJECT = History - Americas/g;
    s/\n\nCALL # = GA.+\n/SUBJECT = Geography/g;
    s/\n\nCALL # = GB.+\n/SUBJECT = Geography/g;
    s/\n\nCALL # = GC.+\n/SUBJECT = Oceanography/g;
    s/\n\nCALL # = GE.+\n/SUBJECT = Environmental Sciences/g;
    s/\n\nCALL # = G[F-T].+\n/SUBJECT = Anthropology/g;
    s/\n\nCALL # = GV.+\n/SUBJECT = Recreation and Leisure/g;
    s/\n\nCALL # = G.+\n/SUBJECT = Geography/g;
    s/\n\nCALL # = HA.+\n/SUBJECT = Statistics/g;
    s/\n\nCALL # = H[B-J].+\n/SUBJECT = Economics, Finance, Business/g;
    s/\n\nCALL # = H[K-Z].+\n/SUBJECT = Sociology/g;
    s/\n\nCALL # = H.+\n/SUBJECT = Social Sciences - General/g;
    s/\n\nCALL # = J.+\n/SUBJECT = Political Science/g;
    s/\n\nCALL # = K.+\n/SUBJECT = Law/g;
    s/\n\nCALL # = L.+\n/SUBJECT = Education/g;
    s/\n\nCALL # = M.+\n/SUBJECT = Music/g;
    s/\n\nCALL # = N.+\n/SUBJECT = Art/g;
    s/\n\nCALL # = PA.+\n/SUBJECT = Language and Literature - Greek, Latin/g;
    s/\n\nCALL # = PB.+\n/SUBJECT = Languages - Modern, Celtic/g;
    s/\n\nCALL # = PC.+\n/SUBJECT = Languages - Romanic/g;
    s/\n\nCALL # = PD.+\n/SUBJECT = Languages - Germanic/g;
    s/\n\nCALL # = PD.+\n/SUBJECT = Languages - English/g;
    s/\n\nCALL # = PF.+\n/SUBJECT = Languages - Germanic/g;
s/\n\nCALL # = PG.+\n/SUBJECT = Language and Literature - Slavic, Baltic, Albanian/g;
    s/\n\nCALL # = PH.+\n/SUBJECT = Languages - Uralic, Finnic, Basque/g;
s/\n\nCALL # = PJ.+\n/SUBJECT = Language and Literature - Afroasiatic, Semitic/g;
s/\n\nCALL # = PK.+\n/SUBJECT = Language and Literature - Indo-Iranian, Armenian, Caucasian/g;
s/\n\nCALL # = PL.+\n/SUBJECT = Language and Literature - Eastern Asian, African, Oceanic/g;
    s/\n\nCALL # = PM.+\n/SUBJECT = Languages - Aboriginal, Artificial/g;
    s/\n\nCALL # = PN.+\n/SUBJECT = Literature - General/g;
    s/\n\nCALL # = PQ.+\n/SUBJECT = Literature - Romanic/g;
    s/\n\nCALL # = PR.+\n/SUBJECT = Literature - English/g;
    s/\n\nCALL # = PS.+\n/SUBJECT = Literature - American/g;
    s/\n\nCALL # = PT.+\n/SUBJECT = Literature - Germanic/g;
    s/\n\nCALL # = PZ.+\n/SUBJECT = Literature - Juvenile/g;
    s/\n\nCALL # = P.+\n/SUBJECT = Philology and Linguistics/g;
    s/\n\nCALL # = QA7[56].+\n/SUBJECT = Computer Science/g;
    s/\n\nCALL # = QA.+\n/SUBJECT = Mathematics/g;
    s/\n\nCALL # = QB.+\n/SUBJECT = Astronomy/g;
    s/\n\nCALL # = QC.+\n/SUBJECT = Physics/g;
    s/\n\nCALL # = QD.+\n/SUBJECT = Chemistry/g;
    s/\n\nCALL # = QE.+\n/SUBJECT = Geology, Earthquakes/g;
    s/\n\nCALL # = Q[H-M].+\n/SUBJECT = Biology/g;
    s/\n\nCALL # = QP.+\n/SUBJECT = Physiology, Neural Networks/g;
    s/\n\nCALL # = QR.+\n/SUBJECT = Microbiology/g;
    s/\n\nCALL # = Q.+\n/SUBJECT = Science - General/g;
    s/\n\nCALL # = R.+\n/SUBJECT = Medicine/g;
    s/\n\nCALL # = S.+\n/SUBJECT = Agriculture, Acquaculture/g;
    s/\n\nCALL # = TK9[001-401].+\n/SUBJECT = Engineering - Nuclear/g;
    s/\n\nCALL # = TL[1-484].+\n/SUBJECT = Engineering - Motor Vehicles/g;
    s/\n\nCALL # = TA.+\n/SUBJECT = Engineering - General, Civil/g;
    s/\n\nCALL # = TC.+\n/SUBJECT = Engineering - Hydraulic, Ocean/g;
    s/\n\nCALL # = TD.+\n/SUBJECT = Engineering - Environmental/g;
    s/\n\nCALL # = TE.+\n/SUBJECT = Engineering - Highway/g;
    s/\n\nCALL # = TF.+\n/SUBJECT = Engineering - Railroads/g;
    s/\n\nCALL # = TG.+\n/SUBJECT = Engineering - Bridges/g;
    s/\n\nCALL # = TH.+\n/SUBJECT = Engineering - Buildings/g;
    s/\n\nCALL # = TJ.+\n/SUBJECT = Engineering - Mechanical/g;
    s/\n\nCALL # = TK.+\n/SUBJECT = Engineering - Electrical, Electronics/g;
    s/\n\nCALL # = TL.+\n/SUBJECT = Engineering - Aeronautics, Astronautics/g;
    s/\n\nCALL # = TN.+\n/SUBJECT = Engineering - Mining, Metallurgy/g;
    s/\n\nCALL # = TP.+\n/SUBJECT = Engineering - Chemical/g;
    s/\n\nCALL # = TS.+\n/SUBJECT = Manufactures/g;
    s/\n\nCALL # = T[RTX].+\n/SUBJECT = Photography, Crafts, Cooking/g;
    s/\n\nCALL # = T.+\n/SUBJECT = Technology/g;
    s/\n\nCALL # = [UV].+\n/SUBJECT = Military, Naval Sciences/g;
    s/\n\nCALL # = Z.+\n/SUBJECT = Library and Information Science/g;
}
