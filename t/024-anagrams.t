#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Test::Deep;
use Games::Word::Wordlist;

my @words = qw/stop spot tops post posts stops spartan poster pot sop spa/;

my $wl = Games::Word::Wordlist->new(\@words);
my @anagrams;
lives_ok(sub { @anagrams = $wl->anagrams("stop") },
            "testing calling random_word with a good word list");

cmp_deeply(\@anagrams, bag('stop', 'spot', 'tops', 'post'),
            "anagrams returns the correct words");
