#!/usr/bin/perl

package main;

use 5.008000;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Liblist;
use Config;

# This 'root' could be manually set here, or
# supplied through an environment variable TIDY_ROOT
###my $iroot = 'F:/Projects/mingw64';
###my $iroot = 'F:/Projects/win64-mt';
my $iroot = $ENV{'TIDY_ROOT'};
if (!$iroot) {
    print <<'EOF';

The environment variable TIDY_ROOT is NOT set. This variable is
used to find your installation of 'Tidy'. It must include 'tidy.h'
in the 'include' folder, and 'tidys.lib' in the 'lib' folder.

See the repository https://github.com/htacg/tidy-html5 for how to
build and install 'Tidy'. It can be built and installed using cmake 
build file generator, probably using the same tools you are using 
here to build this perl wrapper.

EOF
    exit(1);
}

# Have a TIDY_ROOT
my $libs = '-ltidys';
my $inc = "-I. -I$iroot/include";

print "Looking for for Tidy on your system.\n";
my @vars = ExtUtils::Liblist->ext( "-L$iroot/lib -ltidys", 0, 1 );
$libs = $vars[2];

if ( !$libs ) {
    $libs = '-ltidys';
    print <<'EOF';

It seems that you don't have Tidy installed.  HTML::Tidy does no
real work on its own.  It's just a wrapper around library Tidy.

Please read the README.markdown file for details on how to install Tidy.

If you do have Tidy installed, but Makefile.PL can't detect it,
go ahead and try building.  If HTML::Tidy builds and tests correctly,
please file a ticket at Github at
https://github.com/geoffmcl/html-tidy/issues, and maybeo we can fix the
library detection code.

EOF
    } else {
        print "Found and using '$libs'...\n";
    }

eval { require LWP::Simple; };

if ( $@ ) {
    print <<'EOF';

NOTE: It seems that you don't have LWP::Simple installed.
      The webtidy program will not be able to retrieve web pages.

EOF
}

my $parms = {
    NAME                => 'HTML::Tidy',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'lib/HTML/Tidy.pm',
    ABSTRACT_FROM       => 'lib/HTML/Tidy.pm',
    PREREQ_PM           => {
        'Encode'        => 0,   # for tests
        'Exporter'      => 0,
        'Getopt::Long'  => 0,   # in webtidy
        'Test::More'    => '0.98', # For subtest()
        'Test::Builder' => 0,
        'Carp'          => 0,
        'overload'      => 0,
        'constant'      => 0,
    },

    LIBS                => [$libs],
    NEEDS_LINKING       => 1,
    INC                 => $inc,

    EXE_FILES           => [qw(bin/webtidy)],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTML-Tidy-*' },
};

if ( $ExtUtils::MakeMaker::VERSION ge '6.45_01' ) {
    $parms->{META_MERGE} = {
        resources => {
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0.php',
            homepage    => 'https://github.com/geoffmcl/html-tidy',
            bugtracker  => 'https://github.com/geoffmcl/html-tidy/issues',
            repository  => 'https://github.com/geoffmcl/html-tidy',
        }
    };
    $parms->{LICENSE} = 'artistic_2';
}
if ( $ExtUtils::MakeMaker::VERSION ge '6.47_02' ) {
    $parms->{MIN_PERL_VERSION} = 5.008;
}

WriteMakefile( %{$parms} );

sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib --exclude=t/lib \
		--exclude=.svn --exclude='*~' \
		--languages=C,Perl --langmap=Perl:+.t \
		.

critic:
	perlcritic -1 \
		-profile perlcriticrc \
		.

MAKE_FRAG
}
