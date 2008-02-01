#!perl -T
use strict;
use warnings;
use Test::More tests => 4;
use Test::Exception;
use Games::Word::Wordlist;

my @words = qw/foo bar baz/;
my $wl;
lives_ok { $wl = Games::Word::Wordlist->new(\@words) }
         "creating a wordlist from an array succeeds";
is($wl->words, 3, "created the correct number of words in the word list");
$wl->add_words(['zab', 'rab', 'oof', 'foo']);
is($wl->words, 6, "adding words results in the correct number of words");
$wl->remove_words(qw/rab foo quux/);
is($wl->words, 4, "deleting words results in the correct number of words");
