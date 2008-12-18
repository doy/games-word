#!/usr/bin/perl
use strict;
use warnings;
use Games::Word::Wordlist;

my $start = $ARGV[0] or die "Usage: $0 <subword>\n";
my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
my $re = join '.*', sort split(//, $ARGV[0]);
$wl->each_word(sub {
    my $word = shift;
    print "$word\n" if join('', sort split(//, $word)) =~ /$re/i;
});
