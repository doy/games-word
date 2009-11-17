#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

my @modules = qw(Games::Word Games::Word::Wordlist);

for my $module (@modules) {
    use_ok $module or BAIL_OUT("couldn't use $module");
}
