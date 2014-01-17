# Created 2009-01-31 by H Fuchs <code@hfuchs.net>

# --- Introduction
# Option parsing with Perl's GetOptions implementation requires Getopt::Std,
# see 'my_modules.pl' for included modules and pragmas.
# The excellent 'perldoc Getopt::Std' provides almost every necessary
# information.

# --- Defining Expected Options and Calling getops()
# First, I need an hash that will receive the options that were used on the
# command-line when calling this script:

my %options;

# I then define a string which contains the single-character switches for all
# the options I expect to be handling.
# For convenience, I declare the standard options,
#   * v - verbose
#   * d - debug
#   * h - help
#   * t - test
# first and all particular options afterwards, concatenating the two.

my $switches = "vdht";  # standard options
$switches .= ""; # TODO

# Calling getopts(), I now am able to test whether the options specified are
# actually the ones I expect.  If not, getopts() will emit a 'unknown option'
# message.  [TODO] I'm not sure what happens if someone specifies the same
# option twice.

getopts($switches, \%options);

# --- Associating handlers
# The handlers that are used here have been declared (and, usually, also
# defined) previously.  Take a look at the calling script to see where.
# Again, I first associate subroutines to the standard switches and afterwards
# for the specific options.
# Classical handlers:

set_verbose_mode() if ($options{v});
set_debug_mode()   if ($options{d});
display_help()     if ($options{h});
test_myself()      if ($options{t});

# Project-specific handlers:

# TODO
