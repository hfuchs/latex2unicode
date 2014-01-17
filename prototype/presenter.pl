#!/usr/bin/perl
# Created 2009-01-31 by H Fuchs <code@hfuchs.net>
# Purpose
#   Twofold; firstly, I try to emulate literate programming with the help of
#   defining lots of modules that are in themselves small, specific and
#   *readable*.  I believe the last part is what is important.
#   One could call this document-layout programming.  It is similar to what
#   one does with huge LaTeX files.
#   Secondly, I'll feed a tex-file to the excellent 'brightmare' text equation
#   renderer.
# Changelog

# --- Include Modules and Define Pragmas
do "fox_modules.pl";

# --- Declare and Implement subroutines
do "fox_subroutines.pl";

# --- Parse and Check Options
do "fox_option_parser.pl";

# [TODO] The following three paragraphs are probably obsolete as I intend to
# call all subroutines from the option-parser.

# --- Prepare execution
#do "fox_execution_preparator.pl";

# --- Main
do "fox_main.pl";

# --- Clean up and Exit
#do "fox_clean_up.pl";

exit 0;

