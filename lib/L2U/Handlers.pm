#package L2U::Handlers;

use feature qw/switch say/;
# TODO God, how I hate those "(given|when) is experimental" messages!
no warnings;

use L2U::Common;
use List::Util qw/max min reduce/;

sub handle {
    my $cmd = shift; # string
    my $str = shift; # reference
    my $stack = shift; # optional reference
    my $box;

    D("> handle              [$cmd]");

    given($cmd) {
        # TODO This should be a hash table.
        when (/^overline$/)   { $box = handle_bar($str) }
        when (/^bar$/)        { $box = handle_bar($str) }
        when (/^vec$/)   { $box = handle_vec($str) }
        when (/^hat$/)   { $box = handle_hat($str) }
        when (/^dot$/)   { $box = handle_dot($str) }
        when (/^sqrt$/)  { $box = handle_sqrt($str) }
        when (/^frac$/)  { $box = handle_frac($str) }
        when (/^int$/)         { $box = handle_int($str) }
        when (/^sum$/)         { $box = handle_sum($str) }
        # TODO Handle fonts, eg. \mathbb, differently!  See
        # <http://en.wikipedia.org/wiki/Blackboard_bold>.
        when (/^(mathrm|rm)$/)   { $box = handle_dummy($str) }
        when (/^mathbf$/)      { $box = handle_dummy($str) }
        # TODO I should balk when encountering a stray \right or \end!
        when (/left/)        { $box = handle_left($str) }
        when (/begin/)       { $box = handle_begin($str) }
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

    # Set the root's default degree if none's given.
    $degree = make_unity_box('2') if is_empty_box($degree);

    # One-line case first (also: root can be of fourth degree max).
    # Eg. '\sqrt[4]{2\pi i}' -> "\x{221c}2\x{0305}π\x{0305}i\x{0305}" -> ∜2̅π̅i̅
    if ( $arg->{height} == 1 and grep { $_ eq $degree->{content}[0] } (2,3,4) ) {
        my $box = make_empty_box();

        # Define a mapping of degree numbers to Unicode.
        my %map = ( '2' => "\x{221a}", '3' => "\x{221b}", '4' => "\x{221c}" );

        # This puts the combining character for the top bar after every
        # character.  Probably simpler with splice(), but ... I wrote
        # it, it works, waddayawant.
        # Second line: Add appropriate root character in front.
        my $inside = join '', map { "$_" . "\x{0305}" } split '', $arg->{content}[0];
        $box->{content} = [ $map{$degree->{content}[0]} . $inside ];

        return boxify($box);
    }

    # Now for the more general case.
    #
    # Combose the degree-box.
    push @{$degree->{content}}, "\x{2570}" . "\x{2500}" x ($degree->{width});
    unshift @{$degree->{content}}, " "x($degree->{width}) foreach (1 .. ($arg->{height} - 1));

    $degree->{height}  = $arg->{height} + 1;
    $degree->{width}++;
    $degree->{head}    = $arg->{head} + 1;
    $degree->{foot}    = $arg->{foot};
    hpad( 'right', $degree );

    # Compose the separator-box.
    my $sep = make_empty_box();
    $sep->{content} = [ "\x{256d}" ];
    push @{$sep->{content}}, "\x{2502}" foreach (1 .. ($arg->{height} - 1));
    push @{$sep->{content}}, "\x{256f}";
    $sep->{height}  = $arg->{height} + 1;
    $sep->{width}++;
    $sep->{head} = $arg->{head} + 1;
    $sep->{foot} = $arg->{foot};

    # Put the top bar on the argument-box.
    unshift @{$arg->{content}}, "\x{2500}" x $arg->{width};
    $arg->{height}++;
    $arg->{head}++;
    # TODO Do it with combining chars!
    #$arg->{content}->[0] = join '', map { "$_" . "\x{0305}" } split '', $arg->{content}[0];

    # Put it all together and ship it!
    return boxify($degree, $sep, $arg);
}

sub handle_left {
    # Together with make_delim(), this function is responsible for
    # creating scaled versions of *brackets.  Note that I (and LaTeX, as
    # it turns out!) distinguish between symmetric delimiters such as
    # angle brackets and asymmetric delimiters such as parentheses.
    #
    # TODO See http://en.wikipedia.org/wiki/Bracket
    my $str = shift; # Reference
    D("> handle_left");

    # TODO I *need* get_char().
    my $leftdelim = find_block( $str );
    my %pairables = (
        "\x{27e8}" => "\x{27e8}",
        "\x{27e9}" => "\x{27e9}",
        '(' => '(',
        ')' => ')',
        '|' => '|',
        '[' => '[',
        ']' => ']',
    );

    if ( exists $pairables{$leftdelim->{content}->[0]} ) {
        unshift @$str, '\left';
        my $arg         = expand( stackautomaton( $str, '\left', '\right' ) );
        my $rightdelim  = find_block( $str );
        my $left        = make_delim($leftdelim, $arg);
        my $right       = make_delim($rightdelim, $arg);
        return boxify( $left, $arg, $right );
    } else {
        die "unpairable delimiter";
    }
}

sub make_delim {
    D("> make_delim");
    my $delim  = shift;
    my $arg    = shift;
    my $height = $arg->{height};

    $delim = substr $delim->{content}->[0], 0, 1;  # TODO This is just ... borked.

    my %delims = (
        # regular, width-1 delimiters:
        # TODO Document!
        #'(' => [ '('        , "\x{256d}" , "\x{2502}" , "\x{2570}" ],
        #')' => [ ')'        , "\x{256e}" , "\x{2502}" , "\x{256f}" ],
        '|' => [ "\x{2502}" , "\x{2502}" , "\x{2502}" , "\x{2502}" ],
        #'[' => [ '['        , "\x{250c}" , "\x{2502}" , "\x{2514}" ],
        #']' => [ ']'        , "\x{2511}" , "\x{2502}" , "\x{2518}" ],
        # with code block 'Misc Technical':
        '(' => [ '('        , "\x{239B}" , "\x{239C}" , "\x{239D}" ],
        ')' => [ ')'        , "\x{239E}" , "\x{239F}" , "\x{23A0}" ],
        '[' => [ '['        , "\x{23A1}" , "\x{23A2}" , "\x{23A3}" ],
        ']' => [ ']'        , "\x{23A4}" , "\x{23A5}" , "\x{23A6}" ],
        '{' => [ '{'        , "\x{23A7}" , "\x{23A8}" , "\x{23A9}" ],
        '}' => [ '}'        , "\x{23AB}" , "\x{23AC}" , "\x{23AD}" ],
        # variable-width, odd and pathologic delimiters:
        "\x{27e8}" => "handle_langle",
        "<"        => "handle_langle",
        "\x{27e9}" => "handle_rangle",
        ">"        => "handle_rangle",
    );

    my $box;

    if ( scalar( @{$delims{$delim}} ) == 4 ) {
        $box        = make_unity_box( $delims{$delim}->[0] );
        my @content = ();

        if ( $height != 1 ) {
            # TODO Explain reasoning behind asymmetric boxes.
            $height++ if $arg->{foot} != $arg->{head};

            push @content, $delims{$delim}->[1];
            push @content, $delims{$delim}->[2] foreach (1 .. ($height-2));
            push @content, $delims{$delim}->[3];

            $box->{content} = \@content;
            $box->{height}  = $height;
            $box->{foot}  = $arg->{foot};
            $box->{head}  = $arg->{head};

            # Dealing with asymmetric content again.
            $box->{foot}++ if $arg->{foot} < $arg->{head};
            $box->{head}++ if $arg->{foot} > $arg->{head};
        }
    } else { # TODO God help me.
        $box = &{$delims{$delim}}( $arg );
    }

    normalize_box($box);
    return $box;
}

# The angle brackets are currently the only "strictly symmetric"
# delimiters in that they cannot be scaled well to accommodate
# arbitrarly skewed contents.
sub handle_langle {
    D('> handle_langle');
    my $arg     = shift;
    return handle_fooangle( "langle", $arg );
}

sub handle_rangle {
    D('> handle_rangle');
    my $arg     = shift;
    return handle_fooangle( "rangle", $arg );
}

sub handle_fooangle {
    D('> handle_fooangle');

    my $type    = shift;
    my $arg     = shift;
    my $height  = $arg->{height};
    my $box     = make_unity_box( $type eq "langle" ? "\x{27E8}" : "\x{27E9}" );

    if ( $height != 1 ) {

        $height = 2 * min $arg->{foot}, $arg->{head};
        $height += 2 if $arg->{foot} != $arg->{head};

        my @content = ();

        if ( $type eq "rangle" ) {
            push @content, ' 'x$_ . "\x{2572} " foreach ( 0 .. ($height/2)-1 );
            push @content, ' 'x($height/2) . "\x{27E9}";
            push @content, ' 'x$_ . "\x{2571} " foreach reverse ( 0 .. ($height/2)-1 );
        } elsif ( $type eq "langle" ) {
            push @content, ' 'x$_ . "\x{2571}" foreach reverse ( 1 .. ($height/2) );
            push @content, "\x{27E8}";
            push @content, ' 'x$_ . "\x{2572}" foreach ( 1 .. ($height/2) );
        } else {
            die "unsupported angle type: $type";
        }

        $box->{content} = \@content;
        $box->{height}  = $height;
        $box->{foot}    = $height/2;
        $box->{head}    = $height/2;

        normalize_box($box);
    }

    return $box;
}

# Generic environment handler, very similar to handle_left().
sub handle_begin {
    my $str = shift; # Reference
    D("> handle_begin");

    # TODO Options!
    # TODO Bit ugly, don't you think?  How about get_content()?
    my $command = join '', @{find_block( $str )->{content}};
    my $handler = "handle_" . $command;

    die "Unknown environment [$command]." unless ( defined(&{$handler}) );

    unshift @$str, '\begin{' . $command . '}';
    #my $arg         = expand( stackautomaton( $str, '\begin{'.$command.'}', '\end{'.$command.'}' ) );
    my $arg         = stackautomaton( $str, '\begin{'.$command.'}', '\end{'.$command.'}' );

    &{$handler}( [ split //, $arg ] );
    #my $rightdelim  = find_block( $str );
    #my $left        = make_delim($leftdelim, $arg);
    #my $right       = make_delim($rightdelim, $arg);
    #return boxify( $left, $arg, $right );

}

sub handle_array {
    my $str = shift;      # Reference
    D("> handle_array");

    my $opts  = find_block( $str );
    # TODO check_table_sanity()!
    my $table = find_table_elements( $str );

    my @boxes;
    push @boxes, @$_ foreach @$table;


    hpad( @boxes );

    my @rows;
    foreach my $row (@$table) {
        # I *told* you: 'bit of 'askell never hurt nobody!
        # (The same thing done with map() would lead to another unity
        # box at the end.  Can't have that, now can we? :)
        push @rows, reduce { boxify( $a, make_unity_box(), $b ) } @$row;
    }
    # TODO Here we go again.  Implementing vboxify().  hpad() could be
    # doing precisely that - if it wasn't returning $width...
    my @content = ();
    foreach my $row (@rows) {
        push @content, @{$row->{content}};
        push @content, " "x$row->{width};
    }
    pop @content;

    my $box = make_empty_box();
    $box->{content} = \@content;
    normalize_box( $box );
    $box->{head} = $box->{foot} = int( $box->{height} / 2 );

    return $box;
}

sub find_table_elements {
    #
    # Basically:  '0&1\\1&0' -> [ [box(0), box(1)], [box(1), box(0)] ]
    #

    D("> find_table_elements");
    my $str    = shift;      # Reference
    my $string = join '', @$str;
    my @rows   = split /\\\\/, $string;

    my @table;
    foreach my $row (@rows) {
        my @entries;
        # TODO Negative look-behind for '\'?
        foreach my $entry ( split /&/, $row ) {
            push @entries, expand( $entry );
        }
        push @table, [ @entries ];
    }

    return \@table;
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
    $char->{content}->[0] =
    join '', map { "$_" . "\x{0305}" } split '', $char->{content}->[0];
    return $char;
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

    my $intbox = make_unity_box( "\x{222B}" );

    if ($arg->{height} != 1) {
        my @content;
        push @content, "\x{256d}";
        push @content, "\x{2502}";
        push @content, "\x{256f}";
        # TODO with block 'Misc Technical'?  Breaks many tests.
        #push @content, "\x{2320}";
        #push @content, "\x{23AE}"; # foreach (1 .. ($arg->{height}-1));
        #push @content, "\x{2321}";
        $intbox->{content} = \@content;
        $intbox->{head}    = 1;
        $intbox->{foot}    = 1;
    }
    normalize_box($intbox);

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

sub handle_sum {
    # Straight rip-off from handle_int!
    D('> handle_sum');
    my $str             = shift;
    my ($upper, $lower) = find_limits($str);
    my $arg             = find_block($str);

    # Feeling clever, I create an initial box that already contains the
    # proper sign for the "height == 1" case and only afterwards
    # construct a larger sign if necessary.
    my $sumbox = make_unity_box( "\x{03A3}" );

    if ($arg->{height} != 1) {
        # 2014-01-26, How Do I draw a life-sized sigma?
        # 2014-01-27, With characters from Misc Technical (2300—23FF).
        # 1  -> Σ
        # 2? -> "\x{23b2}\n\x{23b3}" -> ⎲
        #                               ⎳
        # 3+ -> ⎽π̲a̲⎽
        #       ╲
        #        >
        #       ╱
        #       ⎺2̅π̅⎺
        #
        # 2014-01-28, First, *any* implementation will do.  I'll stick
        # to the example of handle_int() and use Σ and
        #   ⎽⎽⎽⎽
        #   ╲
        #    〉
        #   ╱
        #   ⎺⎺⎺⎺
        # I don't even have to distinguish between (% 2 == 0) and (%
        # 2 == 1), because of my "baseline" concept.
        # TODO btw: I got confused by those concepts: write an outline!
        #
        my @content;
        push @content, "\x{23BD}"x4;  # TODO Depends on height as well!
        push @content, "\x{2572}";
        push @content, " \x{27E9}";
        push @content, "\x{2571}";
        push @content, "\x{23BA}"x4;

        $sumbox->{content} = \@content;
        normalize_box($sumbox);
    }

    # TODO Make a vboxify function from these lines.
    if ($upper) {
        hpad($upper, $sumbox);
        unshift @{$sumbox->{content}}, @{$upper->{content}};
        push @{$sumbox->{content}}, ' ' if not $lower;
    }
    if ($lower) {
        hpad($lower, $sumbox);
        push @{$sumbox->{content}}, @{$lower->{content}};
        unshift @{$sumbox->{content}}, ' ' if not $upper;
    }
    # TODO Could normalize_box() conceivably do foot/head balancing, too?
    normalize_box($sumbox);
    $sumbox->{foot} = $sumbox->{head} = int( $sumbox->{height}/2 );

    return boxify($sumbox, $arg);
}


1;

