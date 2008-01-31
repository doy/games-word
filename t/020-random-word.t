#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use Games::Word qw/set_word_list random_word/;

my $word_file = '';
$word_file = '/usr/dict/words' if (-f '/usr/dict/words');
$word_file = '/usr/share/dict/words' if (-f '/usr/share/dict/words');

throws_ok(sub { random_word }, qr/No words in word list/,
          "testing calling a function before setting a word list");

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    set_word_list $word_file;
    my $word;
    lives_ok(sub { $word = random_word },
             "testing calling random_word with a good word list");

    open my $fh, '<', $word_file;
    my $passed = 0;
    for (<$fh>) {
        chomp;
        $passed = 1 if $word eq $_;
    }
    ok($passed, "testing that the word is actually in the word list")
}
