use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    'E=mc^2'      => "E=mc²",
    # Lagrange Identity
    '(\vec{a}\times\vec{b})\cdot(\vec{c}\times\vec{d}) = (\vec{a}\cdot\vec{c})(\vec{b}\cdot\vec{d}) - (\vec{b}\cdot\vec{c})(\vec{a}\cdot\vec{d})' =>
    "(a⃗×b⃗)·(c⃗×d⃗)=(a⃗·c⃗)(b⃗·d⃗)-(b⃗·c⃗)(a⃗·d⃗)",
    # Graßmann Identity
    '\vec{a}\times(\vec{b}\times\vec{c}) = \vec{b}(\vec{a}\cdot\vec{c})\,-\,\vec{c}(\vec{a}\cdot\vec{b})' =>
    "a⃗×(b⃗×c⃗)=b⃗(a⃗·c⃗) - c⃗(a⃗·b⃗)",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

