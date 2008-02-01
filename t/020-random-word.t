#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use Games::Word::Wordlist;

my $wl = Games::Word::Wordlist->new(['foo', 'bar', 'baz']);
my $word;
lives_ok(sub { $word = $wl->random_word },
            "testing calling random_word with a good word list");
ok(defined($word), "random_word actually returned a word");

like($word, qr/^(foo|bar|baz)$/,
     "testing that the word is actually in the word list")
