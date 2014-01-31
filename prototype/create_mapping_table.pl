#!/usr/bin/perl
# 2014-01-31, Created by H Fuchs <code@hfuchs.net>
#
# Translate W3C's awe-inspiring unicode.xml to "latex" -> "U+xy" pairs
# for consumption of l2u.
#
# "Translate" will probably mean "beat the poor, probably well-formed
# XML with regexps".  HE IS UPON US!
# Hu, seems I managed to use a parser after all!  Sure, its use is
# discouraged but let no one say I went the easy route.
#

use common::sense;
use Data::Dumper;

# 2014-01-31, In the end, I just wget the thing and be done with it.
#use LWP::Simple;
#my $url  = "http://www.w3.org/Math/characters/unicode.xml";
#my $html = LWP::Simple::get( $url )
#    or die "Cannot wget unicode.xml.";

# --- XML::Simple;
# 2014-01-31, Expected great things from XML::Simple -- turns out that
# "The use of this module in new code is discouraged."  Yet, XML::LibXML
# is typically XML-opaque.  So, yeah:
use XML::Simple;
my $xml = XMLin(
    "unicode.xml",
    #$html,
    KeyAttr => {item => 'name'},
    ForceArray => [ 'item' ],
    Cache => [ 'storable' ],     # Helps.  A lot.
);

# There are essentially three section types ('mathvariants', 'character'
# and 'entitygroups') of which only 'characters' is of interest.
foreach my $entry ( @{$xml->{'character'}} ) {
    #say Dumper $entry;

    # TODO I don't think we are allowed to use Perl forms anymore, eh?
    next unless $entry->{latex};
    my $out;
    if ($entry->{description}->{content}) {
        $out .= $entry->{description}->{content};
    } else {
        $out .= $entry->{description};
    }
    $out .= ": " . $entry->{latex};
    $out .= "( " . $entry->{id} . " )";
    say $out;
}



# --- XML::LibXML;
# TODO Can probably just take the URL, right?
#use XML::LibXML::Reader;
#my $reader = XML::LibXML::Reader->new( location => "unicode.xml" )
#    or die "Cannot read source xml string.";
#
#my $i = 0;
#while ($reader->read) {
#    #processNode($reader);
#    while ($i++ < 100) {
#        say "-"x10 . $i . "-"x10;
#        say $reader->depth;
#        say $reader->nodeType;
#        say $reader->name;
#        say $reader->localName;
#        say $reader->isEmptyElement;
#    }
#}
#
