#!perl -T
use strict;
use warnings;
use Test::More tests => 20;
use Test::Exception;
use Games::Word::Wordlist;

my $word_file = '';
$word_file = '/usr/dict/words' if -r '/usr/dict/words';
$word_file = '/usr/share/dict/words' if -r '/usr/share/dict/words';

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    my $wl = Games::Word::Wordlist->new($word_file, cache => 0);
    my $result;
    for (1..10) {
        lives_ok(sub { $result = $wl->is_word($wl->random_word) },
                 "testing calling is_word");
        ok($result,
           "checking to see if a random word from the word list is a word");
    }
}
