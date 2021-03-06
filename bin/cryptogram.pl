#!/usr/bin/env perl
use strict;
use warnings;
use Games::Word qw/random_permutation/;
# PODNAME: cryptogram.pl

my $alphabet = 'abcdefghijklmnopqrstuvwxyz';
my $key = random_permutation $alphabet;
print "KEY: $key\n";
print "MESSAGE:\n";
my $text = join ' ', @ARGV;
eval "\$text =~ tr/$alphabet/$key/";
print $text, "\n";
