use strict; use warnings; use utf8;
use feature qw/say switch/;

use Test::More 'no_plan';
use Data::Dumper;
use Encode;

my $l2u    = './bin/latex2unicode';

my %good   = (
    # TODO For some reason I have to write '$ E' instead of '$E' here
    # but not on the commandline.
    'Erinnerung an die Vorlesung Quantentheorie 2: Man motiviert die Klein-Gordon- '.
    '(KG-) Gleichung durch die Ersetzung von $ p\rightarrow -i\nabla $ und '.
    '$ E\rightarrow i\partial/\partial t $ in der relativ. Relation $ E^2=p^2+m^2 $.  '.
    'Also $\int{\frac{x}{2}}.$' =>
"Erinnerung an die Vorlesung Quantentheorie 2: Man motiviert die\n".
"Klein-Gordon- (KG-) Gleichung durch die Ersetzung von p→-i∇ und E→i∂/∂t\n".
"                                        ╭ x  \n".
"in der relativ. Relation E²=p²+m². Also │╶─╴.\n".
"                                        ╯ 2  ",

# 2014-02-20, Bit contrived, but here goes:  I need to fortify against
# a non-grapheme-aware implementation of substr().
'The probability density,$\vec{j}$, in non-relativistic (Schrödinger) quantum mechanics is $\left( \vec{j} = \frac{i\hbar}{2m} \left[\psi \nabla \psi^{*} - \psi^{*} \nabla \psi \right] \right)$.' =>
"The probability density,j⃗, in non-relativistic (Schrödinger) quantum\n".
"             ⎛   iħ ⎡   *  *  ⎤⎞ \n".
"mechanics is ⎜j⃗=╶──╴⎣ψ∇ψ -ψ ∇ψ⎦⎟.\n".
"             ⎝   2m            ⎠ ",

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

