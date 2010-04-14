use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './latex2unicode';

my %good   = (
    'x^2_3'    => " 2\nx \n 3",
    '\frac12^3'      => "   3\n 1  \n――― \n 2  ",
    '\frac{\Omega^\theta\Gamma}{2^o}^3' =>
    "     3\n  θ   \n Ω Γ  \n――――― \n   o  \n  2   ",
    '\frac{1^f}{34}^a' =>
    "    a\n  f  \n 1   \n―――― \n 34  ",
    'x=\int^2_3{\frac{1^x}{\Omega^2}' =>
    "  2    \n  ╭  x \n  │ 1  \nx=│――――\n  ╯ Ω² \n  3    ",
    # BrightMare fails at this one
    '\vec{m}=\frac12\int{d^3r \vec{r}\times\vec{j}(\vec{r})}' =>
    "   1              \nm⃗=―――∫d³rr⃗×j⃗(r⃗)\n   2              ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

