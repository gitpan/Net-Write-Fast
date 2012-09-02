#
# $Id: Fast.pm 12 2012-04-14 12:25:44Z gomor $
#
package Net::Write::Fast;
use strict;
use warnings;

use base qw(Exporter DynaLoader);

our $VERSION = '0.11';

__PACKAGE__->bootstrap($VERSION);

our %EXPORT_TAGS = (
   consts => [qw(
   )],
   subs => [qw(
   )],
   vars => [qw(
   )],
);

our @EXPORT_OK = (
   @{$EXPORT_TAGS{vars}},
   @{$EXPORT_TAGS{consts}},
   @{$EXPORT_TAGS{subs}},
);

1;

__END__

=head1 NAME

Net::Write::Fast - create and inject packets fast

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011-2012, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of the Artistic license.
See LICENSE.Artistic file in the source distribution archive.

=cut
