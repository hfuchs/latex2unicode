use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    '\int1'    => "∫1",
    '\int x'   => "∫x",
    '\int{\frac{1}{\Omega^2}' => "╭  1 \n│╶──╴\n╯ Ω² ",
    '\sum_{n=0}^\infty{\frac{3\sqrt{n}}{2}}' =>
    "  ∞      \n".
    "⎽⎽⎽⎽     \n".
    "╲    3√n̅ \n".
    " >  ╶───╴\n".
    "╱     2  \n".
    "⎺⎺⎺⎺     \n".
    " n=0     ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

