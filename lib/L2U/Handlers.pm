#package L2U::Handlers;

use feature qw/switch say/;
# TODO God, how I hate those "(given|when) is experimental" messages!
no warnings;

use L2U::Common;

sub handle {
    my $cmd = shift; # string
    my $str = shift; # reference
    my $stack = shift; # optional reference
    my $box;

    D("> handle [$cmd]");

    given($cmd) {
        # TODO This should be a hash table.
        when (/,/)     { $box = handle_comma($str) }
        when (/bar/)   { $box = handle_bar($str) }
        when (/vec/)   { $box = handle_vec($str) }
        when (/hat/)   { $box = handle_hat($str) }
        when (/dot/)   { $box = handle_dot($str) }
        when (/sqrt/)  { $box = handle_sqrt($str) }
        when (/frac/)  { $box = handle_frac($str) }
        # TODO handle_{power,sub} no longer exist!
        #when (/power/) { $box = handle_power($str, $stack) }
        #when (/sub/)   { $box = handle_sub($str, $stack) }
        when (/int/)         { $box = handle_int($str) }
        when (/mathrm|rm/)   { $box = handle_dummy($str) }
        # TODO Handle \mathbb differently!  See
        # <http://en.wikipedia.org/wiki/Blackboard_bold>.
        when (/mathbf/)      { $box = handle_dummy($str) }
        when (/langle/)      { $box = handle_langle($str) }
        # TODO Just repressing the endtoken seems lame...
        when (/rangle/)      { $box = handle_dummy($str) }
        # TODO More generic:
        #when (/left/)        { $box = handle_left($str) }
        default      { die "Unknown command [$_].  Can't handle." }
    }
    return $box;
}

sub handle_dummy {
    D("> handle_dummy");
    my $str = shift;

    return find_block($str);
    #my $block = find_block($str);
    #return handle($char;
}

sub handle_dot {
    D("> handle_dot");
    my $str = shift;

    # TODO Check for single character!
    my $char = find_block($str);
    # 2010-04-20, Not sure about the character choice here.
    # The 'dot' combining character, \x{0307}, *removes* other combining
    # chars.  So, \x{030a}: small circle?
    # No, the *other* dot.  I used this little trick to find it:
    # Extract combined character from vim's :digraph and
    #   perl -Mcommon::sense -MData::Dumper -MUnicode::Normalize -e 'print Dumper NFD("ȧ")'
    # I do feel a bit smug now, come to think of it, yes.
    $char->{content}->[0] = $char->{content}->[0] . "\x{307}";
    return $char;
}

sub handle_vec {
    D("> handle_vec");
    my $str = shift;

    # TODO Check for single character!
    my $char = find_block($str);
    $char->{content}->[0] = $char->{content}->[0] . "\x{20d7}";
    return $char;
}

sub handle_hat {
    D("> handle_hat");
    my $str = shift;

    # TODO Check for single character!
    my $char = find_block($str);
    # Two alternatives, \x{0362}: arrow below, \x{20d7}: o⃗
    # \x{20d1}: o⃑
    $char->{content}->[0] = $char->{content}->[0] . "\x{0302}";
    return $char;
}

sub handle_sqrt {
    my $str = shift; # Reference
    D("> handle_sqrt");
    my $box;

    # Gather the necessary information.
    my $degree = find_option($str);
    my $arg    = find_block($str);

    # Combose the degree-box
    # TODO Handle one-line case (and degree 2, 3, 4)
    $degree = make_unity_box('2') if is_empty_box($degree);
    push @{$degree->{content}}, " " x ($degree->{width}-1) . "\x{2576}";
    foreach (1 .. ($arg->{height} - 1)) {
        unshift @{$degree->{content}}, " " x $degree->{width};
    }
    $degree->{height}  = $arg->{height} + 1;
    $degree->{width}++;
    $degree->{head}    = $arg->{head} + 1;
    $degree->{foot}    = $arg->{foot};

    # Compose the separator-box
    my $sep = make_empty_box();
    $sep->{content} = [ "\x{256d}" ];
    push @{$sep->{content}}, "\x{2502}" foreach (1 .. ($arg->{height} - 1));
    push @{$sep->{content}}, "\x{256f}";
    $sep->{height}  = $arg->{height} + 1;
    $sep->{width}++;
    $sep->{head} = $arg->{head} + 1;
    $sep->{foot} = $arg->{foot};

    unshift @{$arg->{content}}, "\x{2500}" x $arg->{width};
    $arg->{height}++;
    $arg->{head}++;

    return boxify($degree, $sep, $arg);
}

# TODO Parenthetical macros
sub handle_langle {
    # TODO See http://en.wikipedia.org/wiki/Bracket
    my $str = shift; # Reference
    D("> handle_langle");
    my $box;

    # Gather the necessary information.
    my $arg    = find_ext_block($str, '\langle', '\rangle');

    return $arg;
}

# TODO Trigonometric Functions
sub handle_trigonometric {
    my $name = shift; # String
    my $str  = shift; # Reference
    my $box  = make_unity_box();

    find_block($str);

    return $box;
}

# TODO Create a generic accent-handler
sub handle_bar {
    D("> handle_bar");
    my $str = shift;

    # TODO Check for single character!
    my $char = find_block($str);
    $char->{content}->[0] = $char->{content}->[0] . "\x{0305}";
    return $char;
}

sub handle_comma {
    D("> handle_comma");
    return make_unity_box(' ');
}

sub handle_frac {
    D("> handle_frac");
    my $str = shift; # Reference
    my $box;

    my $num   = find_block($str);
    my $denom = find_block($str);
    hpad($num, $denom);

    my @frac = @{$num->{content}};
    #push @frac, "\x{2015}"x($num->{width}+2);
    push @frac, "\x{2576}" . "\x{2500}"x($num->{width}) . "\x{2574}";
    push @frac, @{$denom->{content}};

    $box = {
        content => \@frac,
        width   => length($frac[0])+2,
        height  => $#frac + 1,
        foot    => $denom->{height},
        head    => $num->{height},
    };
    hpad($box);

    return $box;
}

sub handle_int {
    D('> handle_int');
    my $str             = shift;
    my ($upper, $lower) = find_limits($str);
    my $arg             = find_block($str);

    my @content;
    my $intbox = {
        width => 1,
        height => $arg->{height},
        head => $arg->{head},
        foot => $arg->{foot},
    };

    if ($arg->{height} == 1) {
        @content = ( "\x{222B}" );
    } else {
        push @content, "\x{256d}";
        push @content, "\x{2502}" foreach (1 .. ($arg->{height}-2));
        push @content, "\x{256f}";
    }
    $intbox->{content} = \@content;

    # TODO Make a vboxify function from these lines.
    if ($upper) {
        hpad($upper, $intbox);
        unshift @{$intbox->{content}}, @{$upper->{content}};
        $intbox->{height} += $upper->{height};
        $intbox->{head}   += $upper->{height};
    }
    if ($lower) {
        hpad($lower, $intbox);
        push @{$intbox->{content}}, @{$lower->{content}};
        $intbox->{height} += $lower->{height};
        $intbox->{foot}   += $lower->{height};
    }

    return boxify($intbox, $arg);
}

1;

