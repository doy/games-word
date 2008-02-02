#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use Games::Word::Wordlist;

my $wl = Games::Word::Wordlist->new(['foo', 'bar', 'baz', 'quux']);
my $word;
lives_ok(sub { $word = $wl->random_word },
            "testing calling random_word with a good word list");
ok(defined($word), "random_word actually returned a word");

like($word, qr/^(foo|bar|baz)$/,
     "testing that the word is actually in the word list")
lives_ok(sub { $word = $wl->random_word(4) },
         "random_word doesn't die when given a length");
is($word, 'quux', "testing random_word with a given length");
$word = $wl->random_word(3)
like($word, qr/^(foo|bar|baz)$/,
     "testing that the word was correct");
throws_ok(sub { $wl->random_word(5) }, qr/No words of length 5 in word list/,
          "random_word dies if no words are found");
