use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # 2014-01-26, Importing 'test/0' from the brightmare-0.34.2
    # distribution.  Some of these require just adding a few more
    # character substitutions, but there /are/ quite the crackers in
    # here.  Matrices and all that \left/\right mojo...
    # TODO Also, I'm not at all happy with the \sqrt representation!

'\alpha, \beta, \gamma, \Gamma, \delta, \Delta, \ldots, \omega, \Omega' =>
"α,β,γ,Γ,δ,Δ,…,ω,Ω",

#(p \ominus q) \oplus r = q \ominus (p \oplus r)

#\epsilon \leq 2^{-t}

'\frac{3}{2^2} + 1 + \frac{3^2}{2} = \frac{25}{4}' =>
"  3     3²   25 \n".
"╶──╴+1+╶──╴=╶──╴\n".
" 2²      2    4 ",

'\frac{1}{2} x^2 + \frac{(2x + 3)^3}{177}' =>
" 1     (2x+3)³ \n".
"╶─╴x²+╶───────╴\n".
" 2       177   ",

'\sqrt{1 + \frac1\sqrt{x}}' =>
" ╭──────\n".
" │    1 \n".
"2│1+╶──╴\n".
"╶╯   √x̅ ",


#'\sqrt[\sqrt{2}]{e^x + \frac{1}{e^x}}' =>

'4\cdot\int_0^1 \frac{dt}{1 + t^2} = \pi' =>
"  1        \n".
"  ╭  dt    \n".
"4·│╶────╴=π\n".
"  ╯ 1+t²   \n".
"  0        ",

#\left(\frac{1}{1 + \frac{1}{1 + \frac{1}{1 + \frac{1}{1 + x}}}}\right)^\sqrt{1+x}

#\vartheta \in \left[x^2; +\infty\right)

#e = \lim_{n \to \infty} \left(1 + \frac1n\right)^n

#T(n) = 2T\left(\left\lfloor\frac{n}{2}\right\rfloor\right) + O\left(\sqrt{n}\right)

#\left\|A^{-1}\right\|=\inf_{\left\|x\right\|=1} \left\|Ax\right\|

#\left\{x^{2^2^{\left(2_2_2\right)}}_{2_2_{\left(2^2^2\right)}}\right\}

#(u + v)^n = \sum_{i=0}^n \binom{n}{i} u^{n-i}v^i

#\left|\begin{array}{ccccc}a&b&\frac1c&d&e\\&p^2&q&r_2\\&&z\end{array}\right|

#\left(\begin{array}{lcr}a&b&c\\aaa&bbb&ccc\\aaaaa&bbbbb&ccccc\end{array}\right)

#\left[\begin{array}{rr}1&2\\3&-4\end{array}\right]^5=\left[\begin{array}{rr}1&2^5\\3^5&-2^{10}\end{array}\right]
);

while (my ($in, $out) = each %good) {
    my $got = decode_utf8 `$l2u "$in"`;
    chomp $got;
    # 2014-01-24, These dumps are rather educating.  I'll leave 'em for
    # the time being.
    #say "got, out:";
    #say Dumper $got;
    #say Dumper $out;
    #say "same after normalization";
    use Unicode::Normalize qw(reorder decompose);
    $got = reorder(decompose($got));
    $out = reorder(decompose($out));
    #say Dumper $got;
    #say Dumper $out;
    is $got, $out, "Test: $in";
}

