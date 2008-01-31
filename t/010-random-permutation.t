#!perl -T
use strict;
use warnings;
use Test::More;
use List::Util 'sum';
use Games::Word qw/random_permutation/;

my %blah_permutations = (
    0  => "blah", 1  => "blha", 2  => "balh", 3  => "bahl",
    4  => "bhla", 5  => "bhal", 6  => "lbah", 7  => "lbha",
    8  => "labh", 9  => "lahb", 10 => "lhba", 11 => "lhab",
    12 => "ablh", 13 => "abhl", 14 => "albh", 15 => "alhb",
    16 => "ahbl", 17 => "ahlb", 18 => "hbla", 19 => "hbal",
    20 => "hlba", 21 => "hlab", 22 => "habl", 23 => "halb",
);
plan tests => 1 + (scalar keys %blah_permutations) + 2;

is(random_permutation(""), "", "testing permutation of empty string");
while (my ($k, $v) = each %blah_permutations) {
    is(random_permutation("blah", $k), $v, "testing random_permutation of 'blah'");
}
eval { random_permutation("blah", 24) };
like($@, qr/^invalid permutation index/, "testing permutation index bounds");
eval { random_permutation("blah", -1) };
like($@, qr/^invalid permutation index/, "testing permutation index bounds");
