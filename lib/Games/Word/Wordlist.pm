#!perl
package Games::Word::Wordlist;
use strict;
use warnings;
use Games::Word qw/all_permutations is_subpermutation/;
use List::MoreUtils qw/uniq/;

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
}

sub remove_words {
    my $self = shift;

    delete $self->{word_hash}{$_} for (@_);
    $self->{word_list} = [keys %{$self->{word_hash}}];
}

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

sub is_word {
    my $self = shift;

    return $self->_is_word_cache(@_) if $self->{cache};
    return $self->_is_word_nocache(@_);
}

sub _each_word_cache {
    my $self = shift;
    my $code = shift;

    &$code($_) for @{$self->{word_list}};
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
}

sub _each_word {
    my $self = shift;

    return $self->_each_word_cache(@_) if $self->{cache};
    return $self->_each_word_nocache(@_);
}

sub anagrams {
    my $self = shift;
    my $word = shift;

    return uniq grep { $self->is_word($_) } all_permutations($word);
}

sub words_like {
    my $self = shift;
    my $re = shift;

    my @words = ();
    $self->_each_word(sub { push @words, $_[0] if $_[0] =~ $re });

    return @words;
}

sub subwords_of {
    my $self = shift;
    my $string = shift;

    my @words = ();
    $self->_each_word(sub { push @words, $_[0]
                                if is_subpermutation($_[0], $string)});

    return @words;
}

=head1 NAME

Games::Word::Wordlist - ???

=head1 VERSION

Version 0.01 released ???

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Games::Word::Wordlist;
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

