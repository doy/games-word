#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Games::Word qw/shared_letters shared_letters_by_position/;

my @tests = (
    {a => "abcde", b => "edcba", sl => 5, slbp => 1,
     slbp_full => [undef, undef, 'c', undef, undef]},
    {a => "",      b => "",      sl => 0, slbp => 0,
     slbp_full => []},
    {a => "",      b => "abcde", sl => 0, slbp => 0,
     slbp_full => [undef, undef, undef, undef, undef]},
    {a => "aaa",   b => "aa",    sl => 2, slbp => 2,
     slbp_full => ['a', 'a', undef]},
    {a => "abc",   b => "abcde", sl => 3, slbp => 3,
     slbp_full => ['a', 'b', 'c', undef, undef]},
    {a => "cde",   b => "abcde", sl => 3, slbp => 0,
     slbp_full => [undef, undef, undef, undef, undef]},
    {a => "abcba", b => "aabbc", sl => 5, slbp => 2,
     slbp_full => ['a', undef, undef, 'b', undef]},
    {a => "abcde", b => "cdefg", sl => 3, slbp => 0,
     slbp_full => [undef, undef, undef, undef, undef]},
    {a => "bacaa", b => "gabca", sl => 4, slbp => 2,
     slbp_full => [undef, 'a', undef, undef, 'a']},
);
plan tests => 3 * @tests;

for (@tests) {
    my %test = %$_;
    my $sl = shared_letters($test{a}, $test{b});
    my $slbp = shared_letters_by_position($test{a}, $test{b});
    my @slbp_full = shared_letters_by_position($test{a}, $test{b});
    is($sl, $test{sl},
       "testing shared_letters: '$test{a}' vs '$test{b}'");
    is($slbp, $test{slbp},
       "testing shared_letters_by_position: '$test{a}' vs '$test{b}'");
    is_deeply(\@slbp_full, $test{slbp_full},
       "testing shared_letters_by_position (list): '$test{a}' vs '$test{b}'");
}
