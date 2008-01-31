#!perl
package Games::Word;
require Exporter;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/random_word is_word set_word_list
                random_permutation is_permutation/;

use strict;
use warnings;
use Math::Combinatorics qw/factorial/;
use Test::Deep::NoTest;

my $word_list = '';
my $cache = 1;
my %words = ();
my @words = ();

sub set_word_list {
    $word_list = shift;
    die "Can't read word list: $word_list" unless -r $word_list;
    die "Empty word list: $word_list" unless -s $word_list;
    my %args = (cache => 1, @_);
    if ($args{cache}) {
        open my $fh, $word_list or die "Opening $word_list failed";
        for (<$fh>) {
            chomp;
            $words{$_} = 1;
        }
        @words = keys %words;
        $cache = 1;
    }
    else {
        $cache = 0;
        %words = @words = ();
    }

}

sub _random_word_cache {
    die "No words in word list" unless keys %words;
    return $words[int(rand(@words))];
}

sub _random_word_nocache {
    my $word;

    open my $fh, '<', $word_list or die "Opening $word_list failed";
    while (<$fh>) {
        $word = $_ if int(rand($.)) == 0;
    }
    chomp $word;

    return $word;
}

sub random_word {
    return _random_word_cache if $cache;
    return _random_word_nocache;
}

sub _is_word_cache {
    return $words{$_[0]};
}

sub _is_word_nocache {
    my $word = shift;

    open my $fh, '<', $word_list
        or die "Couldn't open word list: $word_list";
    while (<$fh>) {
        chomp;
        return 1 if $_ eq $word;
    }

    return 0;
}

sub is_word {
    return _is_word_cache(@_) if $cache;
    return _is_word_nocache(@_);
}

sub random_permutation {
    my $word = shift;
    return '' if $word eq '';

    use integer;
    my $len = length $word;
    my $perm_index = shift;
    $perm_index = defined($perm_index) ? $perm_index :
                                         int(rand(factorial($len)));
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

