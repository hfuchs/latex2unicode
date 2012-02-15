use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # 2010-04-14, `pdflatex` complains about "Double superscript" - why
    # should I care?  So, for now, this is a feature; not a bug.
    'x^2^3'    => "x²³",
    '{x}'      => "x",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

