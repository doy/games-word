#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use Games::Word qw/set_word_list random_word is_word/;

my $word_file = '';
$word_file = '/usr/dict/words' if (-f '/usr/dict/words');
$word_file = '/usr/share/dict/words' if (-f '/usr/share/dict/words');

lives_ok(sub { is_word "blah" },
         "testing calling a function before setting a word list");

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    set_word_list $word_file;

    my $result;
    lives_ok(sub { $result = is_word random_word },
             "testing calling random_word with a good word list");
    ok($result,
       "testing checking to see if a random word from the word list is a word");
}
