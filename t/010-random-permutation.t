#!perl -T
use strict;
use warnings;
use Test::More tests => 51;
use Test::Deep;
use Games::Word qw/random_permutation/;

is(random_permutation(""), "", "testing permutation of empty string");

for my $word (qw/foo bar baz quux blah/) {
    for (1..10) {
        cmp_deeply([split //, random_permutation $word], bag(split //, $word),
                   "random tests");
    }
}
