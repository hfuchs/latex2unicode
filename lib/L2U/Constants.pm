# TODO It would probably be simplest to parse
# <http://www.ams.org/STIX/bnb/stix-tbl.asc98feb26>.

my %chars = (
    'log'      => "log",
    'Alpha'    => "\x{0391}", # Not actually defined in LaTeX...
    'Beta'     => "\x{0392}",
    'Gamma'    => "\x{0393}",
    'Delta'    => "\x{0394}",
    'Epsilon'  => "\x{0395}",
    'Zeta'     => "\x{0396}",
    'Eta'      => "\x{0397}",
    'Theta'    => "\x{0398}",
    'Iota'     => "\x{0399}",
    'Kappa'    => "\x{039A}",
    'Lambda'   => "\x{039B}",
    'Mu'       => "\x{039C}",
    'Nu'       => "\x{039D}",
    'Xeta'     => "\x{039E}",
    'Omicron'  => "\x{039F}",
    'Pi'       => "\x{03A0}",
    'Rho'      => "\x{03A1}",
    'Varsigma' => "\x{03A2}",
    'Sigma'    => "\x{03A3}",
    'Tau'      => "\x{03A4}",
    'Ypsilon'  => "\x{03A5}",
    'Phi'      => "\x{03A6}",
    'Chi'      => "\x{03A7}",
    'Psi'      => "\x{03A8}",
    'Omega'    => "\x{03A9}",
    'alpha'    => "\x{03B1}",
    'beta'     => "\x{03B2}",
    'gamma'    => "\x{03B3}",
    'delta'    => "\x{03B4}",
    'epsilon'  => "\x{03B5}",
    'zeta'     => "\x{03B6}",
    'eta'      => "\x{03B7}",
    'theta'    => "\x{03B8}",
    'iota'     => "\x{03B9}",
    'kappa'    => "\x{03BA}",
    'lambda'   => "\x{03BB}",
    'mu'       => "\x{03BC}",
    'nu'       => "\x{03BD}",
    'xeta'     => "\x{03BE}",
    'omicron'  => "\x{03BF}",
    'pi'       => "\x{03C0}",
    'rho'      => "\x{03C1}",
    'varsigma' => "\x{03C2}",
    'sigma'    => "\x{03C3}",
    'tau'      => "\x{03C4}",
    'ypsilon'  => "\x{03C5}",
    'phi'      => "\x{03C6}",
    'chi'      => "\x{03C7}",
    'psi'      => "\x{03C8}",
    'omega'    => "\x{03C9}",
    # Number Chars
    'aleph'    => "\x{2135}",
    'imath'    => "\x{131}", # "\x{E64E}",
    'hbar'     => "\x{127}", # "\x{E2D5}", italic: \x{210F}, capital: \x{126}
    # Operators
    'times'    => "\x{d7}",
    'cdot'     => "\x{b7}",
    'partial'  => "\x{2202}",
    # Signs
    'infty'      => "\x{221e}",
    'propto'     => "\x{221d}",
    'equiv'      => "\x{2261}",
    'll'         => "\x{226a}",
    'gg'         => "\x{226b}",
    'ldots'      => "\x{2026}",
    'leftarrow'  => "\x{2190}",
    'Leftarrow'  => "\x{21D0}",
    'rightarrow' => "\x{2192}",
    'Rightarrow' => "\x{21D2}",
    # TODO These two need to handle arguments.
    #'cos'  => "cos",
    #'sin'  => "sin",
);

my %superscripts = (
    '0' => "\x{2070}",
    '1' => "\x{00b9}",
    '2' => "\x{00b2}",
    '3' => "\x{00b3}",
    '4' => "\x{2074}",
    '5' => "\x{2075}",
    '6' => "\x{2076}",
    '7' => "\x{2077}",
    '8' => "\x{2078}",
    '9' => "\x{2079}",
    '+' => "\x{207a}",
    '-' => "\x{207b}",
    '=' => "\x{207c}",
    '(' => "\x{207d}",
    ')' => "\x{207e}",
    'n' => "\x{207f}",
    'i' => "\x{2071}",
);

my %subscripts = (
    '0' => "\x{2080}",
    '1' => "\x{2081}",
    '2' => "\x{2082}",
    '3' => "\x{2083}",
    '4' => "\x{2084}",
    '5' => "\x{2085}",
    '6' => "\x{2086}",
    '7' => "\x{2087}",
    '8' => "\x{2088}",
    '9' => "\x{2089}",
    '+' => "\x{208a}",
    '-' => "\x{208b}",
    '=' => "\x{208c}",
    '(' => "\x{208d}",
    ')' => "\x{208e}",
    'a' => "\x{2090}",
    'e' => "\x{2091}",
    'o' => "\x{2092}",  # Doesn't work for me!
    'x' => "\x{2093}",
    # TODO Unifont doesn't have these.
    'h' => "\x{2095}",
    'k' => "\x{2096}",
    'l' => "\x{2097}",
    'm' => "\x{2098}",
    'n' => "\x{2099}",
    'p' => "\x{209A}",
    's' => "\x{209B}",
    't' => "\x{209C}",
    # Bit of cheating here: Those are from the "Phonetic Extensions"
    # block.
    'i' => "\x{1D62}",
    # TODO j, ffs! j! -- Jesus, next time get a few more of those pesky
    # physicists on those Consortium chairs.  Yeah, but Klingon, right?
    # Damn hobby linguists.
    'r' => "\x{1D63}",
    'u' => "\x{1D64}",
    'v' => "\x{1D65}",
);


my %complex = (
    'frac'  => 'process_frac',
);

sub get_primitive_chars {
    return \%chars;
}

sub get_superscripts {
    return \%superscripts;
}

sub get_subscripts {
    return \%subscripts;
}

sub get_complex_macros {
    return \%complex;
}

1;
