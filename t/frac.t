use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # 2010-04-11, Can't do the following - get an untrackable "wide
    # character in print" somewhere in the test routines.
    #'\frac12'     => "1\n─\n2",
    '\frac12'         => " 1 \n" . "\x{2015}"x3 . "\n 2 ",
    '\frac{1}{2}'     => " 1 \n" . "\x{2015}"x3 . "\n 2 ",
    '\frac{1}{12}'    => "  1 \n" . "\x{2015}"x4 . "\n 12 ",
    # 2014-01-15, length("a\x{30a}") returns two, but \x{30a} is
    # a combining character.
    '\frac{1}{\dot{a}}'
                      => " 1 \n" . "\x{2015}"x3 . "\n å \n",
    # 2011-01-19, TODO Where's this from?
    #'\frac{y}{x^{e}}+\frac{y^{e}}{x}' =>
    #"       e \n  y   y  \n――――+――――\n  e    x \n x       ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

