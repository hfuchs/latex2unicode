use common::sense;
use Data::Dumper;

# Back-alleys first:
#
# 1) perlunitut isn't saying jack shit about combining characters,
#    composition or normalization.
#
# 2) Unicode::String's length() routine *still* counts combining
#    characters separately.
#
# 3) perlunicode finally talks about all the juicy stuff and introduces
#    '\X', which "matches a logical character, an "extended grapheme
#    cluster" in Standardese." Also:
#    http://stackoverflow.com/questions/203605/how-do-i-match-only-fully-composed-characters-in-a-unicode-string-in-perl

my $string   = "a\x{20d7}";  # Which is "a⃗".
my @count    = ($string =~ /\X/g);
my $length   = @count;

say $length;

