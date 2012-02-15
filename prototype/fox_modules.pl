# ---- Standard Pragmas
# ----------------------------------------------------------------------------
# Those are the standard definitions one loads with probably every project
# just to be on the safe side.  To avoid syntactical errors:

use strict;

# As I'd like to be informed about dubios constructs and the like:

use warnings;

# And, of course, to make matters clear where I stand file-encoding-wise:

use utf8;


# ---- Standard Modules
# ----------------------------------------------------------------------------
# -- Option Parser
# For proper option parsing,

use Getopt::Std;

# In case extended processing is necessary one could also use

#use Getopt::Long;


# ---- Additional Modules
# ----------------------------------------------------------------------------

use XML::DOM::Parser;
#use XML::LibXML;

# ---- Exotic Modules
# ----------------------------------------------------------------------------
# -- Multi-line comments
# If I should need multi-line comments, I could turn to 
# Acme::Comment <http://www.perl.com/pub/a/2002/08/13/comment.html>.
# This is one of the interesting applications of source-code filtering (like
# the Switch-module).  C++-stlye comments are defined like this:

#use Acme::Comment type => 'C++', one_line => 1, own_line => 0;

