#!perl
package Games::Word::Wordlist;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $word_list = shift;
    die "Can't read word list: $word_list" unless -r $word_list;
    die "Empty word list: $word_list" unless -s $word_list;

    my $self = {
        cache => 1,
        @_,

        file => $word_list,
        word_list => [],
        word_hash => {},
    };
    if ($self->{cache}) {
        open my $fh, $word_list or die "Opening $word_list failed";
        for (<$fh>) {
            chomp;
            $self->{word_hash}{$_} = 1;
        }
        $self->{word_list} = [keys %{ $self->{word_hash} }];
    }

    bless $self, $class;
    return $self;
}

sub _random_word_cache {
    my $self = shift;
    my @word_list = @{ $self->{word_list} };
    die "No words in word list" unless @word_list;
    return $word_list[int(rand(@word_list))];
}

sub _random_word_nocache {
    my $self = shift;
    my $word;

    open my $fh, '<', $self->{file} or die "Opening $self->{file} failed";
    while (<$fh>) {
        $word = $_ if int(rand($.)) == 0;
    }
    chomp $word;

    return $word;
}

sub random_word {
    my $self = shift;
    return $self->_random_word_cache if $self->{cache};
    return $self->_random_word_nocache;
}

sub _is_word_cache {
    my $self = shift;
    return $self->{word_hash}{$_[0]};
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

