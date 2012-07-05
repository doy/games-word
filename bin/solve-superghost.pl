#!/usr/bin/env perl
use strict;
use warnings;
use Games::Word::Wordlist;
# PODNAME: solve-superghost.pl

die "Usage: $0 <subword>\n" unless @ARGV;
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
print "$_\n" for $wl->words_like(qr/\Q$ARGV[0]/i);
