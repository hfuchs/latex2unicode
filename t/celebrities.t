use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode --math';

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
    '(\vec{a}\times\vec{b})\cdot(\vec{c}\times\vec{d}) = '.
    '(\vec{a}\cdot\vec{c})(\vec{b}\cdot\vec{d}) - '.
    '(\vec{b}\cdot\vec{c})(\vec{a}\cdot\vec{d})' =>
    '(a⃗⨯b⃗)⋅(c⃗⨯d⃗)=(a⃗⋅c⃗)(b⃗⋅d⃗)-(b⃗⋅c⃗)(a⃗⋅d⃗)',

    # Graßmann Identity
    '\vec{a}\times(\vec{b}\times\vec{c}) = \vec{b}(\vec{a}\cdot\vec{c})\,-\,\vec{c}(\vec{a}\cdot\vec{b})' =>
    'a⃗⨯(b⃗⨯c⃗)=b⃗(a⃗⋅c⃗) - c⃗(a⃗⋅b⃗)',

    # Period of a compound pendulum
    'T=2\pi\sqrt{\frac{J}{mgd}}' =>
"      ╭─────\n".
"      │  J  \n".
"T=2π 2│╶───╴\n".
"    ╰─╯ mgd ",

    # Gauß' Identity
    'e^{i\pi} = -1' => " iπ   \ne  =-1",

    # 2014-02-12, Too dense, but okay for now.
    'e^x = \cos{x} + i \sin{x}' =>
" x           \n".
"e =cosx+isinx",


    # 2014-02-12, Integral representation of Dirac's delta.
'\delta_{kk\'} = \frac{1}{V} \int{d^3r e^{-i(k-k\')\cdot r}' =>
"      1 ╭    -i(k-k')⋅r\n".
"δ   =╶─╴│d³re          \n".
" kk'  V ╯              ",

# 2014-02-15, Klein-Gordon equation (also regression test for
# simultaneous sub/superscript handling :).
'\left( \partial_\mu \partial^\mu + m^2 \right) \psi = 0' =>
"⎛   μ   ⎞   \n".
"⎜∂ ∂ +m²⎟ψ=0\n".
"⎝ μ     ⎠   ",
# 2014-02-15, And the KG probability density.
'\rho = \frac{i\hbar}{2m}\left(\psi^*\partial_t\psi - \psi\partial_t\psi^*\right)' =>
"   iħ ⎛ *        *⎞\n".
"ρ=╶──╴⎜ψ ∂ ψ-ψ∂ ψ ⎟\n".
"   2m ⎝   t    t  ⎠",
# 2014-02-15, Regression test for foot-head mixup in
# process_superscript: invariance of the time evolution operator.
'\left| u_\nu (\vec{r},t) \right|^2 = \left|e^{-iE_\nu t} \right|^2 \cdot \left| u_\nu (\vec{r},t) \right|^2= \left| u_\nu (\vec{r},0) \right|^2' =>
"           │ -iE t│²                      \n".
"│       │² │    ν │  │       │² │       │²\n".
"│u (r⃗,t)│ =│e     │ ⋅│u (r⃗,t)│ =│u (r⃗,0)│ \n".
"│ ν     │  │      │  │ ν     │  │ ν     │ ",

# 2014-02-22, A many-particle state vector in Slater determinant
# representation.
'\Psi (x_1,\ldots ,x_N) = \sum_L{ c_L \frac{1}{\sqrt{N}} \mathrm{det}\left|\left\langle x_j|\phi_{l_k}\right\rangle \right|_{(j,k)}}' =>
"           ⎽⎽⎽⎽         │          │     \n".
"           ╲       1    │ ╱      ╲ │     \n".
"Ψ(x₁,…,x )= ⟩  c ╶──╴det│⟨ x |ϕ   ⟩│     \n".
"        N  ╱    L √N̅    │ ╲ j  l ╱ │     \n".
"           ⎺⎺⎺⎺         │       k  │     \n".
"             L                      (j,k)",

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

