# Copyright (C) 2008 Tsukasa Hamano <hamano@klab.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
#
# $Id: TCC.pm,v 1.4 2008-03-17 14:12:01 hamano Exp $

package C::TCC;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use C::TCC ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
TCC_OUTPUT_MEMORY
TCC_OUTPUT_EXE
TCC_OUTPUT_DLL
TCC_OUTPUT_OBJ
TCC_OUTPUT_PREPROCESS
TCC_OUTPUT_FORMAT_ELF
TCC_OUTPUT_FORMAT_BINARY
TCC_OUTPUT_FORMAT_COFF
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} });

our $VERSION = '0.03';

use constant {
    TCC_OUTPUT_MEMORY     => 0,
    TCC_OUTPUT_EXE        => 1,
    TCC_OUTPUT_DLL        => 2,
    TCC_OUTPUT_OBJ        => 3,
    TCC_OUTPUT_PREPROCESS => 4,
    TCC_OUTPUT_FORMAT_ELF    => 0,
    TCC_OUTPUT_FORMAT_BINARY => 1,
    TCC_OUTPUT_FORMAT_COFF   => 2,
};

require XSLoader;
XSLoader::load('C::TCC', $VERSION);

# Preloaded methods go here.

sub new
{
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;

    $self->{state} = tcc_new();
    return $self;
}

sub DESTROY
{
    my $self = shift;
    print "DESTROY\n";
    tcc_delete($self->{state});
}

sub add_include_path
{
    my $self = shift;
    my $pathname = shift;
    tcc_add_include_path($self->{state}, $pathname);
}

sub add_sysinclude_path
{
    my $self = shift;
    my $pathname = shift;
    tcc_add_include_path($self->{state}, $pathname);
}

sub define_symbol
{
    my $self = shift;
    my $sym = shift;
    my $value = shift;
    tcc_define_symbol($self->{state}, $sym, $value);
}

sub undefine_symbol
{
    my $self = shift;
    my $sym = shift;
    tcc_undefine_symbol($self->{state}, $sym);
}

sub add_file
{
    my $self = shift;
    my $filename = shift;
    tcc_add_file($self->{state}, $filename);
}

sub compile_string
{
    my $self = shift;
    my $buf = shift;
    tcc_compile_string($self->{state}, $buf);
}

sub set_output_type
{
    my $self = shift;
    my $output_type = shift;
    tcc_set_output_type($self->{state}, $output_type);
}

sub add_library_path
{
    my $self = shift;
    my $pathname = shift;
    tcc_add_library_path($self->{state}, $pathname);
}

sub add_library
{
    my $self = shift;
    my $libraryname = shift;
    tcc_add_library($self->{state}, $libraryname);
}

sub add_symbol
{
    my $self = shift;
    my $name = shift;
    my $value = shift;
    tcc_add_symbol($self->{state}, $name, $value);
}

sub output_file
{
    my $self = shift;
    my $filename = shift;
    tcc_output_file($self->{state}, $filename);
}

sub run
{
    my $self = shift;
    my @args = @_;
    tcc_run($self->{state}, \@args);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

C::TCC - Perl extension for TCC

=head1 SYNOPSIS

  use C::TCC;
  my $tcc = C::TCC->new();
  $tcc->compile_string('int main(){printf("Hello World.\n"); return 0;}');
  $tcc->run();

=head1 DESCRIPTION

The perl module TCC provides an interface to the TCC(Tiny C Compiler)
See http://fabrice.bellard.free.fr/tcc/ for more information on TCC.

=head1 CONSTRUCTOR

=over 4

=item C<new>

Create a new TCC compilation context.

=head1 METHODS

=over 4

=item C<add_include_path>

Add include path

=item C<tcc_add_sysinclude_path>

Add in system include path

=item C<tcc_define_symbol>

Define preprocessor symbol 'sym'. Can put optional value

=item C<tcc_undefine_symbol>

Undefine preprocess symbol 'sym'

=item C<add_file>

Add a file (either a C file, dll, an object, a library or an ld
script). Return -1 if error.

=item C<compile_string>

Compile a string containing a C source. Return non zero if error.

=item C<run>

link and run main() function and return its value. DO NOT call
tcc_relocate() before.

=head1 SEE ALSO

http://fabrice.bellard.free.fr/tcc/

=head1 AUTHOR

Tsukasa Hamano <hamano@klab.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 Tsukasa Hamano <hamano@klab.org>

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA

=cut
