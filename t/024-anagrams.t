#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Test::Deep;
use Games::Word::Wordlist;

my $word_file = '';
$word_file = '/usr/dict/words' if -r '/usr/dict/words';
$word_file = '/usr/share/dict/words' if -r '/usr/share/dict/words';

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    my $wl = Games::Word::Wordlist->new($word_file);
    my @anagrams;
    lives_ok(sub { @anagrams = $wl->anagrams("stop") },
             "testing calling random_word with a good word list");

    cmp_deeply(\@anagrams, bag('stop', 'spot', 'tops', 'post'),
               "anagrams returns the correct words");
}
