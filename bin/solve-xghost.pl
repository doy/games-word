#!/usr/bin/env perl
use strict;
use warnings;
use Games::Word::Wordlist;

die "Usage: $0 <subword>\n" unless @ARGV;
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
my $re = join '.*', split(//, $ARGV[0]);
print "$_\n" for $wl->words_like(qr/$re/i);
