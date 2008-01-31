#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;
use Games::Word::Wordlist;

my $word_file = '';
$word_file = '/usr/dict/words' if -r '/usr/dict/words';
$word_file = '/usr/share/dict/words' if -r '/usr/share/dict/words';

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    my $wl = Games::Word::Wordlist->new($word_file, cache => 0);
    my $word;
    lives_ok(sub { $word = $wl->random_word },
             "testing calling random_word with a good word list");
    ok(defined($word), "random_word actually returned a word");

    open my $fh, '<', $word_file;
    my $passed = 0;
    for (<$fh>) {
        chomp;
        $passed = 1 if $word eq $_;
    }
    ok($passed, "testing that the word is actually in the word list")
}
