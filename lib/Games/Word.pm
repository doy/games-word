#!perl
package Games::Word;
require Exporter;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/random_permutation is_permutation all_permutations
                shared_letters shared_letters_by_position
                random_string_from
                is_substring all_substrings/;

use strict;
use warnings;
use Math::Combinatorics qw/factorial/;
use Test::Deep::NoTest;

sub random_permutation {
    my $word = shift;

    return '' unless $word;

    my $letter = substr $word, int(rand length $word), 1, '';

    return $letter . random_permutation($word);
}

sub is_permutation {
    my @word_letters = split //, shift;
    my @perm_letters = split //, shift;

    return eq_deeply(\@word_letters, bag(@perm_letters));
}

sub _permutation {
    my $word = shift;
    my $perm_index = shift;

    return '' if $word eq '';

    my $len = length $word;
    die "invalid permutation index" if $perm_index >= factorial($len) ||
                                       $perm_index < 0;

    use integer;

    my $current_index = $perm_index / factorial($len - 1);
    my $rest = $perm_index % factorial($len - 1);

    my $first_letter = substr($word, $current_index, 1);
    substr($word, $current_index, 1) = '';

    return $first_letter . _permutation($word, $rest);
}

sub all_permutations {
    my $word = shift;

    my @ret = ();
    push @ret, _permutation($word, $_)
        for 0..(factorial(length $word) - 1);

    return @ret;
}

sub shared_letters {
    my @a = sort split //, shift;
    my @b = sort split //, shift;

    my @letters = ();
    my ($a, $b) = (shift @a, shift @b);
    while (defined $a && defined $b) {
        if ($a eq $b) {
            push @letters, $a;
            ($a, $b) = (shift @a, shift @b);
        }
        elsif ($a lt $b) {
            $a = shift @a;
        }
        else {
            $b = shift @b;
        }
    }

    return @letters;
}

sub shared_letters_by_position {
    my @a = split //, shift;
    my @b = split //, shift;

    my @letters = ();
    while (my ($a, $b) = (shift @a, shift @b)) {
        last unless (defined $a && defined $b);
        if ($a eq $b) {
            push @letters, $a;
        }
        else {
            push @letters, undef;
        }
    }

    return wantarray ? @letters : grep { defined } @letters;
}

sub random_string_from {
    my ($letters, $length) = @_;

    die "invalid letter list" if length $letters < 1 && $length > 0;
    my @letters = split //, $letters;
    my $ret = '';
    $ret .= $letters[int rand @letters] for 1..$length;

    return $ret;
}

sub is_substring {
    my ($substring, $string) = @_;

    return 1 unless $substring;
    my $re = join('?', map { quotemeta } split(//, $string)) . '?';
    return $substring =~ $re;
}

sub all_substrings {
    my $string = shift;

    return ('') unless $string;

    my @substrings = ($string);
    my $before = '';
    my $current = substr $string, 0, 1, '';
    while ($current) {
        @substrings = (@substrings,
                       map { $before . $_ } all_substrings($string));
        $before .= $current;
        $current = substr $string, 0, 1, '';
    }

    return @substrings;
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

