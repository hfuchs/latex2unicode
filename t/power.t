use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    # Here-docs are no solution.  :)
    '1^2'    => "1²",
    '1^{23}' => " 23\n1  ",
    '1^\omega' => " ω\n1 ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

