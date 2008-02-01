#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Games::Word::Wordlist;

my $word_file = '';
$word_file = '/usr/dict/words' if -r '/usr/dict/words';
$word_file = '/usr/share/dict/words' if -r '/usr/share/dict/words';

SKIP: {
    skip "Can't find a system word list", 2 if $word_file eq '';

    my $wl;
    lives_ok { $wl = Games::Word::Wordlist->new($word_file) }
             "opening a word list from a file doesn't die";
    open my $fh, '<', $word_file or die "Couldn't open $word_file";
    for (<$fh>) {}
    is($wl->words, $., "we read in the correct number of words");
}
