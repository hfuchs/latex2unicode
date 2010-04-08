use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Test::Exception;
use Data::Dumper;

my $l2u    = './latex2unicode';

my %good   = (
    '1+1=2'           => "1+1=2\n",
    '2  +1 =3'        => "2+1=3\n",
);

while (my ($in, $out) = each %good) {
    my $got = `$l2u $in`;
    print "in: $in, out: $out, got: $got\n";
    is $got, $out, "Test: $in";
}

