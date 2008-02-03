#!perl -T
use strict;
use warnings;
use Test::More tests => 5;
use Test::Exception;
use Games::Word::Wordlist;

my $word_file = '';
$word_file = '/usr/dict/words' if -r '/usr/dict/words';
$word_file = '/usr/share/dict/words' if -r '/usr/share/dict/words';

SKIP: {
    skip "Can't find a system word list", 5 if $word_file eq '';

    my $wl = Games::Word::Wordlist->new($word_file, cache => 0);
    my $word = $wl->random_word;
    ok(defined($word), "random_word actually returned a word");

    open my $fh, '<', $word_file;
    my $passed = 0;
    for (<$fh>) {
        chomp;
        $passed = 1 if $word eq $_;
    }
    ok($passed, "testing that the word is actually in the word list");

    lives_ok(sub { $word = $wl->random_word(4) },
             "random_word doesn't die when given a length");

    is(length $word, 4, "testing random_word with a given length");

    is($wl->random_word(35), undef,
       "random_word returns undef if no words are found");
}
