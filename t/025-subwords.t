#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Test::Deep;
use Games::Word::Wordlist;

my @words = qw/stop spot tops post posts stops spartan poster pot sop spa/;

my $wl = Games::Word::Wordlist->new(\@words);
my @subwords;
lives_ok(sub { @subwords = $wl->subwords_of("stop") },
            "testing calling random_word with a good word list");

cmp_deeply(\@subwords, bag('stop', 'spot', 'tops', 'post', 'pot', 'sop'),
            "subwords_of returns the correct words");
