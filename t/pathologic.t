use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

my %good   = (
    # 2010-04-14, `pdflatex` complains about "Double superscript" - why
    # should I care?  So, for now, this is a feature; not a bug.
    'x^2^3'    => "x²³",
    '{x}'      => "x",
    '\frac{1} {2}' =>
" 1 \n".
"╶─╴\n".
" 2 ",
    # 2014-02-07, I know!  Try it!  pdflatex does it.
    '\frac{1} {x^  2}' =>
"  1 \n".
"╶──╴\n".
" x² ",

# 2014-02-21, Interesting.  Again, my intuition matches latex' practice.
'a=\left\langle\frac{1}{\frac{1}{\frac{1}{2\pi}}}\right|' =>
"    ╱        │\n".
"   ╱     1   │\n".
"a=⟨  ╶──────╴│\n".
"   ╲     1   │\n".
"    ╲ ╶────╴ │\n".
"         1   │\n".
"       ╶──╴  │\n".
"        2π   │",

);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    is $got, $out, "Test: $in";
}

