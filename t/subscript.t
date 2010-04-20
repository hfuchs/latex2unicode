use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # Here-docs are no solution.  :)
    '1_1'    => "1₁",
    '1_{23}' => "1  \n 23",
    '1_\theta' => "1 \n θ",
    #'1_o'  should be subscripted, but doesn't work right now...
    'x_{10}_{34}' => "x    \n 10  \n   34",
    'x_{00}_{11}_{22}_{33}' =>
    "x        \n 00      \n   11    \n     22  \n       33",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

