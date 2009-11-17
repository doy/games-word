#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;
use Games::Word::Wordlist;

my @words = qw/stop spot tops post posts stops spartan poster pot sop spa/;

my $wl = Games::Word::Wordlist->new(\@words);
my @anagrams = $wl->anagrams("stop");

cmp_deeply(\@anagrams, bag('stop', 'spot', 'tops', 'post'),
            "anagrams returns the correct words");
