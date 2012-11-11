#
# $Id: Fast.pm 27 2012-11-10 16:36:33Z gomor $
#
package Net::Write::Fast;
use strict;
use warnings;

use base qw(Exporter DynaLoader);

our $VERSION = '0.14';

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

   use Net::Write::Fast;

   # Sends multiple TCP SYNs to multiple IPv6 targets
   my $r = Net::Write::Fast::l4_send_tcp_syn_multi(
      "::1",            # IPv6 source
      [ '::2', '::3' ], # IPv6 targets
      [ 25, 80, 110 ],  # TCP port targets
      200,              # Number of packet per second
      3,                # Number of try
      1,                # Use IPv6
   );

   # Handle errors
   if ($r == 0) {
      print STDERR "ERROR: ",Net::Write::Fast::nwf_geterror(),"\n";
   }

=head1 DESCRIPTION

Sends network frames fast to the network.

=head1 FUNCTIONS

=over 4

=item B<l4_send_tcp_syn_multi> (ip_src, ip_dst arrayref, ip_dst count, ports arrayref, ports count, packets per second, try count, use IPv6 flag)

Sends multiple TCP SYN at layer 4 to multiple IP targets. Returns 0 in case of failure, and sets error buffer to an error message.

=item B<nwf_geterror>

Get latest error message.

=back

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011-2012, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of the Artistic license.
See LICENSE.Artistic file in the source distribution archive.

=cut
