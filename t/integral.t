use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    '\int1'    => "∫1",
    '\int{\frac{1}{\Omega^2}' => "╭  1 \n│――――\n╯ Ω² ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

