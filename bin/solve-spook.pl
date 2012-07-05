#!/usr/bin/env perl
use strict;
use warnings;
use Games::Word::Wordlist;
# PODNAME: solve-spook.pl

die "Usage: $0 <letter_pool>\n" unless @ARGV;
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
my $re = join '.*', sort split(//, $ARGV[0]);
$wl->each_word(sub {
    my $word = shift;
    print "$word\n" if join('', sort split(//, $word)) =~ /$re/i;
});
