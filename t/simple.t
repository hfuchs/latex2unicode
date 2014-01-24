use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
#use Test::Exception;
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    '1+1=2'           => "1+1=2",
    '2  +1 =3'        => "2+1=3",
    '\alpha'          => "α",
    '2\cdot\Omega-7'  => "2·Ω-7",
    '1\times2'        => "1×2",
    '\propto\infty'   => "∝∞",
    '\aleph\equiv'    => 'ℵ≡',
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

