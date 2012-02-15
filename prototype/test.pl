#!/usr/bin/perl

use XML::DOM;

my $file = 'db.xml';

my $parser = XML::DOM::Parser->new();

my $doc = $parser->parsefile($file);

foreach my $species ($doc->getElementsByTagName('species')){
  print $species->getElementsByTagName('common-name')->item(0)
            ->getFirstChild->getNodeValue;
  print ' (' . $species->getAttribute('name') . ') ';
  print $species->getElementsByTagName('conservation')->item(0)

            ->getAttribute('status');
  print "\n";
}

