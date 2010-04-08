use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Test::Exception;
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    '1+1=2'           => "1+1=2",
    '2  +1 =3'        => "2+1=3",
    '\alpha'          => "α",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

