use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
#use Test::Exception;
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

my %good   = (
'\omega(k) = 2\cdot\sqrt{\frac{\kappa}{m}}\left|\sin\frac{ka}{2}\right|' =>
"         ╭───         \n".
"         │ κ │    ka │\n".
"ω(k)=2⋅ 2│╶─╴│sin╶──╴│\n".
"       ╰─╯ m │     2 │",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

