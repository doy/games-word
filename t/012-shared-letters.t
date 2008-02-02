#!perl -T
use strict;
use warnings;
use Test::More;
use Games::Word qw/shared_letters shared_letters_by_position/;

my @tests = (
    {a => "abcde", b => "edcba", sl => 5, slbp => 1},
    {a => "",      b => "",      sl => 0, slbp => 0},
    {a => "",      b => "abcde", sl => 0, slbp => 0},
    {a => "aaa",   b => "aa",    sl => 2, slbp => 2},
    {a => "abc",   b => "abcde", sl => 3, slbp => 3},
    {a => "cde",   b => "abcde", sl => 3, slbp => 0},
    {a => "abcba", b => "aabbc", sl => 5, slbp => 2},
    {a => "abcde", b => "cdefg", sl => 3, slbp => 0},
    {a => "bacaa", b => "gabca", sl => 4, slbp => 2},
);
plan tests => 2 * @tests;

for (@tests) {
    my %test = %$_;
    is(shared_letters($test{a}, $test{b}), $test{sl},
       "testing shared_letters");
    is(shared_letters_by_position($test{a}, $test{b}), $test{slbp},
       "testing shared_letters_by_position");
}
