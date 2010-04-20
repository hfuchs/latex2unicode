use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

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
    '\sqrt[4]{\frac12}' => " ╭───\n │ 1 \n4│―――\n╶╯ 2 ",
    '\sqrt[14]{\frac{12}{32\cdot a_4}}' =>
    "  ╭───────\n  │   12  \n14│―――――――\n ╶╯ 32·a₄ ",
    # TODO Most tests with vectors lie - the combining char eats space!
    '\int_{i=1}^\infty{\sqrt[14]{\int_{-\infty}^0{dx^3\frac{12\vec{x}}{32\cdot a_4}}}}' =>
    " ∞                \n ╭   ╭────────────\n │   │ 0          \n │   │ ╭     12x⃗ \n │   │ │dx³―――――――\n │ 14│ ╯    32·a₄ \n ╯  ╶╯-∞          \ni=1               ",
    '\int\frac12\vec{x}' =>
    "╭ 1  \n│―――x⃗\n╯ 2  ",
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    is $got, $out, "Test: $in";
}

