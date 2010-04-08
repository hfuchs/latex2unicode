#!/usr/bin/perl

use warnings; use strict; use utf8;
use Test::Harness;

my $dir = 't';
opendir my $dh, $dir or die $!;
my @tests = map { $_ = "$dir/$_" } grep { /\.t$/ } readdir $dh;
closedir $dh;

runtests(@tests);

