BEGIN {
    # Overriding length() with a custom implementation.  Why?
    # Standard length() returns number of characters (*not* bytes as the
    # documentation stresses), just not logical or combined or
    # "composed" characters (the latter seems to be official Unicode
    # Consortium parlance).  So, length("a\x{30a}") != length("å").
    # I could've just implemented mylength(), but as I am already using
    # length() all over the place, I'll go for "override CORE
    # namespace".  Gently, though, very verbose!
    # TODO Why not use Unicode::Normalize strategically?  A round-trip
    # of compose(reorder(decompose(.))) should set lengt() straight, eh?
    *CORE::GLOBAL::length = sub {
        my $string = shift;
        my @count = ($string =~ /\X/g);
        my $length = @count;
        #say STDERR "length: $length";
        return $length;
    };
}

1;
