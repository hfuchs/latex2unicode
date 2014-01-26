use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # Euler-Lagrange Equations
    # 2014-01-25, They have now achieved a form most beautiful!
    '\frac{d}{dt} \frac{\partial L}{\partial\dot{q}_i} = \frac{\partial L}{\partial q_i}' =>
"  d   ∂L    ∂L \n".
"╶──╴╶───╴=╶───╴\n".
" dt  ∂q̇ᵢ   ∂qᵢ ",

    # Energy-Mass-Equivalence
    'E=mc^2' =>
    "E=mc²",

    # Lagrange Identity
    '(\vec{a}\times\vec{b})\cdot(\vec{c}\times\vec{d}) = (\vec{a}\cdot\vec{c})(\vec{b}\cdot\vec{d}) - (\vec{b}\cdot\vec{c})(\vec{a}\cdot\vec{d})' =>
    "(a⃗×b⃗)·(c⃗×d⃗)=(a⃗·c⃗)(b⃗·d⃗)-(b⃗·c⃗)(a⃗·d⃗)",

    # Graßmann Identity
    '\vec{a}\times(\vec{b}\times\vec{c}) = \vec{b}(\vec{a}\cdot\vec{c})\,-\,\vec{c}(\vec{a}\cdot\vec{b})' =>
    "a⃗×(b⃗×c⃗)=b⃗(a⃗·c⃗) - c⃗(a⃗·b⃗)",

    # Period of a compound pendulum
    'T=2\pi\sqrt{\frac{J}{mgd}}' =>
    "     ╭─────\n     │  J  \nT=2π2│╶───╴\n    ╶╯ mgd ",

    # Gauß' Identity
    'e^{i\pi} = -1' => " iπ   \ne  =-1",

    # TODO 'e^x = \cos{x} + i \sin{x}'
);

# TODO Rampant code duplication in all .t files.
while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

