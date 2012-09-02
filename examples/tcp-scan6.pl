#!/usr/bin/perl
#
# $Id: tcp-scan.pl 11 2012-01-10 14:38:18Z gomor $
#
use strict;
use warnings;

my $target = shift or die("Give target");
my $pps    = shift or die("Give pps");
my $pass   = shift || 2;

use Net::Frame::Device;

my $dev = Net::Frame::Device->new(target6 => $target);

use Net::Write::Fast;

use Net::Frame::Simple;
use Net::Frame::Dump::Online2;
use Net::Frame::Layer::ETH qw(:consts);
use Net::Frame::Layer::IPv6;
use List::Util 'shuffle';

my @default = (1..1024);
my %ports = map { $_ => 1 } @default;

my $eth = Net::Frame::Layer::ETH->new(
   src  => $dev->mac,
   dst  => $dev->lookupMac6($target),
   type => NF_ETH_TYPE_IPv6,
);
print $eth->print,"\n";

my $ip6 = Net::Frame::Layer::IPv6->new(
   src => $dev->ip6,
   dst => $target,
);
print $ip6->print,"\n";

my %open   = ();
my %closed = ();
for my $p (1..$pass) {
   my $d = Net::Frame::Dump::Online2->new(
      dev    => $dev->dev,
      filter => '((tcp[13] & 2 != 0) and (tcp[13] & 16 != 0) and src host '.
                $target.') or '.
                '((tcp[13] & 4 != 0) and (tcp[13] & 16 != 0) and src host '.
                $target.')',
   );
   #print $d->filter,"\n";
   $d->start;

   my @send = shuffle(keys %ports);
   my $nreq  = scalar(@send);
   my $r = Net::Write::Fast::l4_send_tcp_syn(
      $dev->ip6,
      $target,
      \@send,
      $pps,
      1,
      $eth->pack,
      $ip6->pack,
   ) or print Net::Write::Fast::nwf_geterror(),"\n";

   my $nrep = 0;
   while (1) {
      if (my $f = $d->next) {
         my $s = Net::Frame::Simple->newFromDump($f);
         #printf STDERR "flags: 0x%02x\n", $s->ref->{TCP}->flags;
         if ($s->ref->{TCP}) {
            if ($s->ref->{TCP}->flags == 0x12) { # SYN+ACK
               #print STDERR "open: ".$s->ref->{TCP}->src."\n";
               $open{$s->ref->{TCP}->src}++;
               delete $ports{$s->ref->{TCP}->src};
            }
            elsif ($s->ref->{TCP}->flags == 0x14) { # RST+ACK
               $closed{$s->ref->{TCP}->src}++;
               delete $ports{$s->ref->{TCP}->src};
            }
         }
         $nrep++;
      }
      if ($d->timeout)  {
         #print STDERR "Timeout\n";
         $d->timeoutReset;
         last;
      }
   }

   print "Ratio[$p]: $nrep/$nreq\n";
   my @list = sort { $a <=> $b } keys %open;
   for (@list) {
      print "open: $_/tcp\n";
   }
   @list = sort { $a <=> $b } keys %closed;
   for (@list) {
      print "closed: $_/tcp\n";
   }

   $d->stop;
}
