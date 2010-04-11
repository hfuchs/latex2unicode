my %chars = (
    'Alpha'    => "\x{0391}",
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
    # Operators
    'times' => "\x{d7}",
    'cdot'  => "\x{b7}",
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
    'o' => "\x{2092}",
    'x' => "\x{2093}",
    # TODO Character 'upside-down e'
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
