use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # 2010-04-11, Can't do the following - get an untrackable "wide
    # character in print" somewhere in the test routines.
    # 2014-01-24, HA!  Solved *that* old nut!
    '\frac12'     => "1\n╶─╴\n2",
    '\frac12'         => " 1 \n" . "╶─╴" . "\n 2 ",
    '\frac{1}{2}'     => " 1 \n" . "╶─╴" . "\n 2 ",
    '\frac{1}{12}'    => "  1 \n" . "╶──╴" . "\n 12 ",

    # 2014-01-15, length("a\x{30a}") returns two, but \x{30a} is
    # a combining character.
    # 2014-01-24, Fixed that by using a custom length() routine, but now
    # Test::More's is() getting confused between composed and decomposed
    # representations of LATIN SMALL LETTER A WITH RING ABOVE.
    # http://www.fileformat.info/info/unicode/char/e5/index.htm
    # Two possible solutions:
    #   i) always specify the decomposed variant in tests
    #   ii) use CPAN (Unicode::Normalize or sth like that).
    # #2 it is.
    '\frac{1}{\dot{a}}'
                      => " 1 \n" . "╶─╴" . "\n ȧ ",
    # 2011-01-19, TODO Where's this from?
    #'\frac{y}{x^{e}}+\frac{y^{e}}{x}' =>
    #"       e \n  y   y  \n――――+――――\n  e    x \n x       ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    # 2014-01-24, These dumps are rather educating.  I'll leave 'em for
    # the time being.
    #say "got, out:";
    #say Dumper $got;
    #say Dumper $out;
    #say "same after normalization";
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    #say Dumper $got;
    #say Dumper $out;
    is $got, $out, "Test: $in";
}

