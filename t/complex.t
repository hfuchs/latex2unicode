use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

my %good   = (
    'x^2_3' =>
    " 2\nx \n 3",

    # 2014-02-12, Not sure what the point is here, but I'll leave it in.
    '\frac12^3' =>
" 1 ³\n".
"╶─╴ \n".
" 2  ",

    # 2014-02-12, Updated for new superscript handler and actual parens!
    #'\frac{\Omega^\theta\Gamma}{2^o}^3' =>
'\left(\frac{\Omega^\theta\Gamma}{2^o}\right)^3' =>
"⎛  θ  ⎞³\n".
"⎜ Ω Γ ⎟ \n".
"⎜╶───╴⎟ \n".
"⎜   o ⎟ \n".
"⎝  2  ⎠ ",

    '\frac{1^f}{34}^a' =>
    "    a\n  f  \n 1   \n╶──╴ \n 34  ",

    # 2014-02-12, Static integral sign.  Much improved.
    'x=\int^2_3{\frac{1^x}{\Omega^2}' =>
"  2  x \n".
"  ╭ 1  \n".
"x=│╶──╴\n".
"  ╯ Ω² \n".
"  3    ",

    # BrightMare fails at this one
    '\vec{m}=\frac12\int{d^3r \vec{r}\times\vec{j}(\vec{r})}' =>
    "   1           \n".
    "m⃗=╶─╴∫d³rr⃗⨯j⃗(r⃗)\n".
    "   2           ",

'\sqrt[4]{\frac12}' =>
"  ╭───\n".
"  │ 1 \n".
" 4│╶─╴\n".
"╰─╯ 2 ",

'\sqrt[14]{\frac{12}{32\cdot a_4}}' =>
"   ╭───────\n".
"   │   12  \n".
" 14│╶─────╴\n".
"╰──╯ 32⋅a₄ ",

    # 2010-04-17, Most tests with vectors lie - the combining char eats space!
    # 2014-01-24, Not anymore!  Logical length() saves the test, once again.
    # 2014-02-12, New, static-size integral sign.
    '\int_{i=1}^\infty{\sqrt[14]{\int_{-\infty}^0{dx^3\frac{12\vec{x}}{32\cdot a_4}}}}' =>
"      ╭────────────\n".
" ∞    │ 0          \n".
" ╭    │ ╭     12x⃗  \n".
" │    │ │dx³╶─────╴\n".
" ╯  14│ ╯    32⋅a₄ \n".
"i=1╰──╯-∞          ",


    '\int\frac12\vec{x}' =>
    "╭ 1  \n│╶─╴x⃗\n╯ 2  ",

    # 2012-02-15, Interesting: Pasting the output of latex2unicode into another
    # terminal (with this file open), the combined character 'J\x{302}'
    # became '\x{134}' which is not what L2U returns...
    # Is this Unicode Normalization in action?
    # 2014-01-24, Yes.
    '[\hat{J}_a,\hat{\mathbf{j}}^2]=0' => "[J\x{302}ₐ,j\x{302}²]=0",

    # 2014-02-12, Glorious.  Just glorious.
'L = \frac12 \int_0^R{dx \left[\rho\left(\frac{\partial q}{\partial t}\right)^2 - \sigma \left(\frac{\partial q}{\partial x}\right)^2 \right]}' =>
"     R                     \n".
"   1 ╭  ⎡ ⎛ ∂q ⎞²  ⎛ ∂q ⎞²⎤\n".
"L=╶─╴│dx⎢ρ⎜╶──╴⎟ -σ⎜╶──╴⎟ ⎥\n".
"   2 ╯  ⎣ ⎝ ∂t ⎠   ⎝ ∂x ⎠ ⎦\n".
"     0                     ",

# 2014-03-02, Field operator.  \sum's now independent of it's "argument".
'\Psi = \frac{1}{\sqrt{V}}\sum_k e^{i\vec{k}\cdot\vec{r}} a_{\vec{k}}' =>
"      ⎽⎽⎽⎽       \n".
"    1 ╲    ik⃗⋅r⃗  \n".
"Ψ=╶──╴ ⟩  e    a \n".
"   √V̅ ╱         k⃗\n".
"      ⎺⎺⎺⎺       \n".
"        k        ",

);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    use Unicode::Normalize qw(reorder compose decompose);
    $got = compose(reorder(decompose($got)));
    $out = compose(reorder(decompose($out)));
    is $got, $out, "Test: $in";
}

