use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

my %good   = (
    # Here-docs are no solution.  :)
    '1^2'    => "1²",
    '1^{23}' => " 23\n1  ",
    '1^\omega' => " ω\n1 ",
    'x^{12}^{21}^{42}' => "     42\n   21  \n 12    \nx      ",
    # This one failed mysteriously (started with 'x¹}...').
    'x^{10}^{21}^{42}' => "     42\n   21  \n 10    \nx      ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

