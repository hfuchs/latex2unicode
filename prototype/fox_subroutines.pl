# Created 2009-01-31 by H Fuchs <code@hfuchs.net>

# ---- Subroutine Declarations
# ----------------------------------------------------------------------------
# ATTENTION: Keep these in sync with the definitions.  Same file: sync should
# be easy, right?  These declarations only serve as an overview, technically
# I don't need them, as the definition itself appears before its use, so these
# forward declarations are redundant.  The overview comes with a decent editor
# that does folding well enough [TODO].

# -- Standard Subroutines
# These functions correspond to the standard command-line switches that should
# be defined in each and every project.  And for once the names *are*
# self-explaining.

sub set_verbose_mode;
sub set_debug_mode;
sub display_help;
sub test_myself;
sub parse_db;

# -- Specific subroutines
# TODO

# ---- Implementations
# ----------------------------------------------------------------------------
# TODO: comments
# ------------------------
sub set_verbose_mode {
	#TODO
}
# ------------------------
sub set_debug_mode {
	#TODO
}
# ------------------------
sub display_help { # TODO: PODify this
   print "\nUsage: $0 [-v] [-h] [-c dir|p file] [-t]\n";
   print "   -v  verbose\n";
   print "   -h  help\n";
   print "   -c  create HTML document from [source dir]\n";
   print "   -p  parse HTML document [file]\n";
   print "   -t  self-test\n";
   print "\n";

   exit -1;
}
# ------------------------
sub test_myself {
	#TODO
}
# ------------------------
sub parse_db {
	# perldoc XML::DOM
	print "Hi!\n";

	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile("db.xml"); # TODO variable

	print $doc->toString;
	$doc->printToFile ("out.xml");

	$doc->dispose;
}
