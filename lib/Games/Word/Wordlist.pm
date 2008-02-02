#!perl
package Games::Word::Wordlist;
use strict;
use warnings;
use Games::Word qw/all_permutations is_subpermutation/;
use List::MoreUtils qw/uniq/;

=head1 NAME

Games::Word::Wordlist - manages a list of words

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Games::Word::Wordlist;
    my $wl = Games::Word::Wordlist->new('/usr/share/dict/words');
    my $word = $wl->random_word;
    print "we have a word" if $wl->is_word($word);

=head1 DESCRIPTION

Games::Word::Wordlist manages a list of words, either from a wordlist file on
your computer or from a list of words you specify. You can use it to query
things about the list, such as whether a given string is a word, or how many
words are in the list, and you can also get words from the list, either
randomly or by regex.

=cut

=head1 CONSTRUCTOR

=head2 new()

The constructor initializes the word list with words, either from a file or
from an arrayref, given as the first argument. The remaining arguments are a
paramhash which recognizes these options:

=over 4

=item cache

Whether or not we want to keep an in memory cache of the words in the word
list. Defaults to true, since this is what we want in almost all cases, as it
speeds up lookups by several orders of magnitude. Can be set to false if either
memory is a significant issue (word lists can be several megabytes in size) or
if the word list is expected to change frequently during the running of the
program.

=back

=cut

sub new {
    my $class = shift;
    my $word_list = shift;
    my $self = {
        cache => 1,
        @_,

        file => $word_list,
        word_list => [],
        word_hash => {},
    };

    if (ref($word_list) eq 'ARRAY') {
        $self->{cache} = 1;
        $self->{file} = '';
        $self->{word_list} = $word_list;
        $self->{word_hash}{$_} = 1 for @$word_list;
    }
    else {
        die "Can't read word list: $word_list" unless -r $word_list;
        die "Empty word list: $word_list" unless -s $word_list;
        if ($self->{cache}) {
            open my $fh, $word_list or die "Opening $word_list failed";
            for (<$fh>) {
                chomp;
                $self->{word_hash}{$_} = 1;
            }
            $self->{word_list} = [keys %{$self->{word_hash}}];
        }
    }

    bless $self, $class;
    return $self;
}

=head1 METHODS

=head2 add_words

Add words to the word list. Only works if the word list has been cached.

Takes either a reference to an array containing the new words, or the name of a
file to read in the words from. Ignores any words already in the word list.

=cut

sub add_words {
    my $self = shift;
    my $word_list = shift;

    die "Can't add words to a non-cached word list"
        unless $self->{cache};

    if (ref($word_list) eq 'ARRAY') {
        $self->{word_hash}{$_} = 1 for @$word_list;
    }
    else {
        open my $fh, '<', $word_list or die "Opening $word_list failed";
        $self->{word_hash}{$_} = 1 for <$fh>;
    }
    $self->{word_list} = [keys %{$self->{word_hash}}];

    return;
}

=head2 remove_words

Removes words from the word list. Only works if the word list is cached.

Takes a list of words to remove (ignoring words that aren't in the word list).

=cut

sub remove_words {
    my $self = shift;

    die "Can't remove words from a non-cached word list"
        unless $self->{cache};

    delete $self->{word_hash}{$_} for (@_);
    $self->{word_list} = [keys %{$self->{word_hash}}];

    return;
}

=head2 words

Returns the number of words in the word list.

=cut

sub words {
    my $self = shift;

    return @{$self->{word_list}} if $self->{cache};
    open my $fh, '<', $self->{file};
    for (<$fh>) {}
    return $.;
}

sub _random_word_cache {
    my $self = shift;
    my $length = shift;

    my @word_list;
    if (defined $length) {
        @word_list = $self->words_like(qr/^\w{$length}$/);
        die "No words in word list" unless @word_list;
    }
    else {
        @word_list = @{$self->{word_list}};
        die "No words of length $length in word list" unless @word_list;
    }

    return $word_list[int rand @word_list];
}

sub _random_word_nocache {
    my $self = shift;
    my $length = shift;

    open my $fh, '<', $self->{file} or die "Opening $self->{file} failed";
    die "No words in word list" unless -s $self->{file};
    my $word;
    my $lineno = 0;
    while (<$fh>) {
        next unless !defined $length || /^\w{$length}$/;
        $lineno++;
        $word = $_ if int(rand $lineno) == 0;
    }
    die "No words of length $length in word list" unless defined $word;
    chomp $word;

    return $word;
}

=head2 random_word

Returns a random word from the word list, optionally of a specified length.

Takes a single optional integer argument, which will make it only consider
words of that length in its search.

=cut

sub random_word {
    my $self = shift;

    return $self->_random_word_cache(@_) if $self->{cache};
    return $self->_random_word_nocache(@_);
}

sub _is_word_cache {
    my $self = shift;
    my $word = shift;

    return $self->{word_hash}{$word};
}

sub _is_word_nocache {
    my $self = shift;
    my $word = shift;

    open my $fh, '<', $self->{file}
        or die "Couldn't open word list: $self->{file}";
    while (<$fh>) {
        chomp;
        return 1 if $_ eq $word;
    }

    return 0;
}

=head2 is_word

Tests whether a word is in the word list.

Takes a single argument, the word to be tested.

Returns true if the word is found in the word list, false otherwise.

=cut

sub is_word {
    my $self = shift;

    return $self->_is_word_cache(@_) if $self->{cache};
    return $self->_is_word_nocache(@_);
}

sub _each_word_cache {
    my $self = shift;
    my $code = shift;

    &$code($_) for @{$self->{word_list}};

    return;
}

sub _each_word_nocache {
    my $self = shift;
    my $code = shift;

    open my $fh, '<', $self->{file}
        or die "Couldn't open word list: $self->{file}";
    while (<$fh>) {
        chomp;
        &$code($_);
    }

    return;
}

sub _each_word {
    my $self = shift;

    return $self->_each_word_cache(@_) if $self->{cache};
    return $self->_each_word_nocache(@_);
}

=head2 anagrams

Finds all anagrams of a given string.

Takes an argument of a string.

Returns a list of all permutations of that string that are found in the word
list.

=cut

sub anagrams {
    my $self = shift;
    my $word = shift;

    return uniq grep { $self->is_word($_) } all_permutations($word);
}

=head2 words_like

Searches through the word list by regex.

Takes an argument of a regex.

Returns a list containing all words in the word list matching that regex.

=cut

sub words_like {
    my $self = shift;
    my $re = shift;

    my @words = ();
    $self->_each_word(sub { push @words, $_[0] if $_[0] =~ $re });

    return @words;
}

=head2 subwords_of

Searches for words which can be made using the letters of a given string.

Takes an argument of a string.

Returns a list of words from the word list which can be made using the letters
in that string.

=cut

sub subwords_of {
    my $self = shift;
    my $string = shift;

    my @words = ();
    $self->_each_word(sub { push @words, $_[0]
                                if is_subpermutation($_[0], $string)});

    return @words;
}

=head1 SEE ALSO

L<Games::Word>

=head1 AUTHOR

Jesse Luehrs, C<< <jluehrs2 at uiuc.edu> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-games-word at rt.cpan.org>, or browse
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Word>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Games::Word::Wordlist

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

