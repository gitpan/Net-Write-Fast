#
# $Id: Makefile.PL 24 2012-11-06 22:28:23Z gomor $
#
use ExtUtils::MakeMaker;

WriteMakefile(
   NAME             => 'Net::Write::Fast',
   VERSION_FROM     => 'lib/Net/Write/Fast.pm',
   LICENSE          => 'artistic',
   ABSTRACT_FROM    => 'lib/Net/Write/Fast.pm',
   AUTHOR           => 'GomoR <gomor-cpan_at_gomor.org>',
   MIN_PERL_VERSION => '5.6.1',
);
