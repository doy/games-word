#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Games::Word::Wordlist;

my $wl;
lives_ok { $wl = Games::Word::Wordlist->new([]) }
         "creating a wordlist succeeds";
isa_ok $wl, "Games::Word::Wordlist";
