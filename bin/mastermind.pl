#!/usr/bin/env perl
use strict;
use warnings;
use Games::Word qw/random_string_from shared_letters
                   shared_letters_by_position/;

my $word = random_string_from "abcdefg", 5;
while (1) {
    print "Guess? ";
    my $guess = <>;
    chomp $guess;
    last if $guess eq $word;
    my $gears = shared_letters_by_position $guess, $word;
    my $tumblers = shared_letters($guess, $word) - $gears;
    printf "You hear $tumblers tumbler%s and $gears gear%s.\n",
           $tumblers == 1 ? '' : 's',
           $gears    == 1 ? '' : 's';
}
print "You see the drawbridge open.\n";
