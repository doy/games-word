#!perl
package Games::Word;
require Exporter;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/random_permutation is_permutation all_permutations
                shared_letters shared_letters_by_position/;

use strict;
use warnings;
use Math::Combinatorics qw/factorial/;
use Test::Deep::NoTest;

sub random_permutation {
    my $word = shift;
    my $perm_index = shift;

    return '' if $word eq '';

    use integer;

    my $len = length $word;
    $perm_index = defined($perm_index) ? $perm_index :
                                         int rand factorial $len;
    die "invalid permutation index" if $perm_index >= factorial($len) ||
                                       $perm_index < 0;
    my $current_index = $perm_index / factorial($len - 1);
    my $rest = $perm_index % factorial($len - 1);

    my $first_letter = substr($word, $current_index, 1);
    substr($word, $current_index, 1) = '';

    return $first_letter . random_permutation($word, $rest);
}

sub is_permutation {
    my @word_letters = split //, shift;
    my @perm_letters = split //, shift;

    return eq_deeply(\@word_letters, bag(@perm_letters));
}

sub all_permutations {
    my $word = shift;

    my @ret = ();
    push @ret, random_permutation($word, $_)
        for 0..(factorial(length $word) - 1);

    return @ret;
}

sub shared_letters {
    my @a = sort split //, shift;
    my @b = sort split //, shift;

    my @letters = ();
    my ($a, $b) = (pop @a, pop @b);
    while (defined $a && defined $b) {
        if ($a eq $b) {
            push @letters, $a;
            ($a, $b) = (pop @a, pop @b);
        }
        elsif ($a lt $b) {
            $a = pop @a;
        }
        else {
            $b = pop @b;
        }
    }

    return @letters;
}

sub shared_letters_by_position {
    my @a = split //, shift;
    my @b = split //, shift;

    my @letters = ();
    while (my ($a, $b) = (pop @a, pop @b)) {
        if ($a eq $b) {
            push @letters, $a;
        }
        else {
            push @letters, undef;
        }
    }

    return wantarray ? @letters : grep { defined } @letters;
}

=head1 NAME

Games::Word - ???

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Games::Word;
    do_stuff();

=head1 DESCRIPTION



=head1 SEE ALSO

L<Foo::Bar>

=head1 AUTHOR

Jesse Luehrs, C<< <jluehrs2 at uiuc.edu> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-games-word at rt.cpan.org>, or browse
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Word>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Games::Word

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-Word>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-Word>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Word>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-Word>

=back

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Jesse Luehrs.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

