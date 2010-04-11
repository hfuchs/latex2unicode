use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    # 2010-04-11, Can't do the following - get an untrackable "wide
    # character in print" somewhere in the test routines.
    #'\frac12'     => "1\n─\n2",
    '\frac12'     => "1\n\x{2015}\n2",
    '\frac{1}{2}'     => "1\n\x{2015}\n2",
    '\frac{1}{12}'    => " 1\n" . "\x{2015}"x2 . "\n12",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

