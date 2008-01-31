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
    skip "Can't find a system wordlist", 2 unless $word_file;
    my $wl;
    lives_ok { $wl = Games::Word::Wordlist->new($word_file) }
             "creating a wordlist succeeds";
    isa_ok $wl, "Games::Word::Wordlist";
}
