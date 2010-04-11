my %chars = (
    'Alpha' => "\x{0391}",
    'Beta'  => "\x{0392}",
    'Gamma' => "\x{0393}",
    'Delta' => "\x{0394}",
    'Zeta'  => "\x{0395}",
    'Eta'   => "\x{0396}",
    'Theta' => "\x{0397}",
    'Iota'  => "\x{0397}",
    'Kappa' => "\x{0397}",
    # TODO
    'Omega' => "\x{03A9}",
    'alpha' => "\x{03B1}",  # Or just 'α'?
    'times' => "\x{d7}",
    'cdot'  => "\x{b7}",
);

my %complex = (
    'frac'  => 'process_frac',
);

sub get_primitive_chars {
    return \%chars;
}

sub get_complex_macros {
    return \%complex;
}

1;
