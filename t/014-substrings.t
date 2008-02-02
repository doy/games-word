#!perl -T
use strict;
use warnings;
use Test::More;
use Test::Deep;
use List::Util qw/sum/;
use Games::Word qw/is_substring all_substrings/;

my %is_substring_tests = (
    ""      => [""],
    "abc",  => ["", "abc", "ab", "ac"],
    "aaba"  => ["a", "aa", "aaa", "aab", "aba"],
    "abcba" => ["aa", "bb", "c", "abc", "cba", "abba"],
);
my %all_substrings_tests = (
    ""    => [''],
    "a"   => ['', "a"],
    "ab"  => ['', "a", "b", "ab"],
    "aab" => ['', "a", "a", "b", "aa", "ab", "ab", "aab"],
    "abc" => ['', "a", "b", "c", "ab", "ac", "bc", "abc"],
);
plan tests => (sum map { scalar @$_ } values %is_substring_tests) +
              keys %all_substrings_tests;

while (my ($word, $substrings) = each %is_substring_tests) {
    ok(is_substring($_, $word), "is '$_' a substring of '$word'?")
        for @$substrings;
}
while (my ($word, $substrings) = each %all_substrings_tests) {
    cmp_deeply([all_substrings($word)], bag(@$substrings),
               "do we get all of the substrings of '$word'?");
}
