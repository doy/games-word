#!/usr/bin/perl
use strict;
use warnings;
use Games::Word::Wordlist;

die "Usage: $0 <word_prefix>\n" unless @ARGV;
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
print "$_\n" for $wl->words_like(qr/^\Q$ARGV[0]/i);
