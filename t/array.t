use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

my %good   = (
# 2014-02-22, Finally.
'a=\left(\begin{array}{cc} 0 & \sigma \\\\ \sigma & 0 \end{array}\right)' =>
"  ⎛0 σ⎞\n".
"a=⎜   ⎟\n".
"  ⎝σ 0⎠",

'a=\left(\begin{array}{cc} 0 & \sigma \\\\ -2\pi\vec{\imath} & \frac12 \end{array}\right)' =>
"  ⎛  0    σ ⎞\n".
"  ⎜         ⎟\n".
"a=⎜       1 ⎟\n".
"  ⎜-2πı⃗  ╶─╴⎟\n".
"  ⎝       2 ⎠",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u '$in'`;
    chomp $got;
    use Data::Dumper;
    #say Dumper $l2u . "$in";
    use Unicode::Normalize qw(reorder compose decompose);
    $got = compose(reorder(decompose($got)));
    $out = compose(reorder(decompose($out)));
    is $got, $out, "Test: $in";
}

