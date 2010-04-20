use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    '\sqrt{2}'     => "2╭─\n╶╯2",
    '\sqrt{23}'    => "2╭──\n╶╯23",
    '\sqrt[4]{23}' => "4╭──\n╶╯23",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

