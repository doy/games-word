#!perl -T
use strict;
use warnings;
use Test::More;
use Test::Deep;
use List::Util qw/sum/;
use Games::Word qw/is_subpermutation all_subpermutations/;

my %is_subpermutation_tests = (
    ""      => [""],
    "abc",  => ["", "abc", "ab", "ac", "cb", "bac", "ca"],
    "aaba"  => ["a", "aa", "aaa", "aab", "aba"],
    "abcba" => ["aa", "bb", "c", "abc", "cba", "abba", "bbaac", "caa"],
);
my %all_subpermutations_tests = (
    ""    => [""],
    "a"   => ["", "a"],
    "ab"  => ["", "a", "b", "ab", "ba"],
    "aab" => ["", "a", "a", "b", "aa", "ab", "ab", "ba", "ba", "aa",
              "aab", "aab", "aba", "aba", "baa", "baa"],
    "abc" => ["", "a", "b", "c", "ab", "ac", "bc", "ba", "ca", "cb",
              "abc", "acb", "bac", "bca", "cab", "cba"],
);
plan tests => (sum map { scalar @$_ } values %is_subpermutation_tests) +
              keys %all_subpermutations_tests;

while (my ($word, $subpermutations) = each %is_subpermutation_tests) {
    ok(is_subpermutation($_, $word), "is '$_' a subpermutation of '$word'?")
        for @$subpermutations;
}
while (my ($word, $subpermutations) = each %all_subpermutations_tests) {
    cmp_deeply([all_subpermutations($word)], bag(@$subpermutations),
               "do we get all of the subpermutations of '$word'?");
}
