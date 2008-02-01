#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Games::Word::Wordlist;

my $wl = Games::Word::Wordlist->new(['foo', 'bar', 'baz']);
my $result;
lives_ok(sub { $result = $wl->is_word($wl->random_word) },
            "testing calling is_word");
ok($result,
    "testing checking to see if a random word from the word list is a word");
