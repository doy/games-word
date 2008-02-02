#!/usr/bin/perl
use strict;
use warnings;
use Games::Word::Wordlist;

my $start = $ARGV[0] or die "Usage: $0 <subword>\n";
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
my $re = join '.*', split(//, $ARGV[0]);
print "$_\n" for $wl->words_like(qr/$re/i);
