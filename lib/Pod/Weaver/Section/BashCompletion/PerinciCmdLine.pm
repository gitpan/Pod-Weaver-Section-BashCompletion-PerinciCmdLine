package Pod::Weaver::Section::BashCompletion::PerinciCmdLine;

our $DATE = '2014-11-08'; # DATE
our $VERSION = '0.01'; # VERSION

use 5.010001;
use Moose;
with 'Pod::Weaver::Role::Section';

use Moose::Autobox;

sub weave_section {
    my ($self, $document, $input) = @_;

    my $filename = $input->{filename} || 'file';
    #my $name = $input->{zilla}->name; # dist name

    my $command_name;
    if ($filename =~ m!^(bin|script)/(.+)$!) {
        $command_name = $2;
    } else {
        $self->log_debug(["skipped file %s (not an executable)", $filename]);
        return;
    }
    my $content = do {
        open my($fh), "<", $filename or die "Can't open $filename: $!";
        local $/;
        ~~<$fh>;
    };
    #unless ($content =~ /\A#!.+perl/) {
    #    $self->log_debug(["skipped file %s (not a Perl script)",
    #                      $filename]);
    #    return;
    #}
    unless ($content =~ /(use|require)\s+Perinci::CmdLine(::Any|::Lite)?/) {
        $self->log_debug(["skipped file %s (does not use Perinci::CmdLine)",
                          $filename]);
        return;
    }

    my $text = <<_;
This script has bash completion capability.

To activate bash completion for this script, put:

 complete -C $command_name $command_name

in your bash startup (e.g. C<~/.bashrc>). Your next shell session will then
recognize tab completion for the command. Or, you can also directly execute the
line above in your shell to activate immediately.

You can also install L<App::BashCompletionProg> which makes it easy to add
completion for Perinci::CmdLine-based scripts. Just execute
C<bash-completion-prog> and the C<complete> command will be added in your
C<~/.bash-completion-prog>. Your next shell session will then recognize tab
completion for the command.

_

    $document->children->push(
        Pod::Elemental::Element::Nested->new({
            command  => 'head1',
            content  => 'BASH COMPLETION',
            children => [
                map { s/\n/ /g; Pod::Elemental::Element::Pod5::Ordinary->new({ content => $_ })} split /\n\n/, $text
            ],
        }),
    );
}

no Moose;
1;
# ABSTRACT: Add a BASH COMPLETION section for Perinci::CmdLine-based scripts

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::Section::BashCompletion::PerinciCmdLine - Add a BASH COMPLETION section for Perinci::CmdLine-based scripts

=head1 VERSION

This document describes version 0.01 of Pod::Weaver::Section::BashCompletion::PerinciCmdLine (from Perl distribution Pod-Weaver-Section-BashCompletion-PerinciCmdLine), released on 2014-11-08.

=head1 SYNOPSIS

In your C<weaver.ini>:

 [BashCompletion::PerinciCmdLine]

=head1 DESCRIPTION

This section plugin adds a BASH COMPLETION section for Perinci::CmdLine-based
scripts. The section contains information on how to activate bash completion for
the scripts.

=for Pod::Coverage weave_section

=head1 SEE ALSO

L<Perinci::CmdLine>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Pod-Weaver-Section-BashCompletion-PerinciCmdLine>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Pod-Weaver-Section-BashCompletion-PerinciCmdLine>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Pod-Weaver-Section-BashCompletion-PerinciCmdLine>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
