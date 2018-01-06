#!/usr/bin/perl -w
# NAME: modmakefile.pl
# AIM: VERY SPECIFIC - Remove a '-nodefaultlib' option from a Makefile
use strict;
use warnings;
use File::Basename;  # split path ($name,$dir,$ext) = fileparse($file [, qr/\.[^.]*/] )
use Cwd;
my $os = $^O;
my $perl_dir = '/home/geoff/bin';
my $PATH_SEP = '/';
my $temp_dir = '/tmp';
if ($os =~ /win/i) {
    $perl_dir = 'C:\GTools\perl';
    $temp_dir = $perl_dir;
    $PATH_SEP = "\\";
}
# unshift(@INC, $perl_dir);
# require 'lib_utils.pl' or die "Unable to load 'lib_utils.pl' Check paths in \@INC...\n";
# log file stuff
# our ($LF);
my $pgmname = $0;
if ($pgmname =~ /(\\|\/)/) {
    my @tmpsp = split(/(\\|\/)/,$pgmname);
    $pgmname = $tmpsp[-1];
}
# my $outfile = $temp_dir.$PATH_SEP."temp.$pgmname.txt";
# open_log($outfile);

# user variables
my $VERS = "0.0.7 2018-01-04";
#my $VERS = "0.0.6 2017-05-24";
my $load_log = 0;
my $in_file = '';
my $verbosity = 0;
my $out_file = '';

# ### DEBUG ###
my $debug_on = 0;
my $def_file = 'F:\Projects\html-tidy-pet-fork\Makefile';

### program variables
my @warnings = ();
my $cwd = cwd();

# NO lib_utils.pl, so
sub prt($) { print shift; }

# RENAME A FILE TO .OLD, or .BAK
# 0 - do nothing if file does not exist.
# 1 - rename to .OLD if .OLD does NOT exist
# 2 - rename to .BAK, if .OLD already exists,
# 3 - deleting any previous .BAK ...
sub rename_2_old_bak {
	my ($fil) = shift;
	my $ret = 0;	# assume NO SUCH FILE
	if ( -f $fil ) {	# is there?
		my ($nm,$dir,$ext) = fileparse( $fil, qr/\.[^.]*/ );
		my $nmbo = $dir . $nm . '.old';
		$ret = 1;	# assume renaming to OLD
		if ( -f $nmbo) {	# does OLD exist
			$ret = 2;		# yes - rename to BAK
			$nmbo = $dir . $nm . '.bak';
			if ( -f $nmbo ) {
				$ret = 3;
				unlink $nmbo;
			}
		}
		rename $fil, $nmbo;
	}
	return $ret;
}

sub write2file {
	my ($txt,$fil) = @_;
	open WOF, ">$fil" or die("ERROR: Unable to open $fil! $!\n");
	print WOF $txt;
	close WOF;
}

sub VERB1() { return $verbosity >= 1; }
sub VERB2() { return $verbosity >= 2; }
sub VERB5() { return $verbosity >= 5; }
sub VERB9() { return $verbosity >= 9; }

sub show_warnings($) {
    my ($val) = @_;
    if (@warnings) {
        prt( "\nGot ".scalar @warnings." WARNINGS...\n" );
        foreach my $itm (@warnings) {
           prt("$itm\n");
        }
        prt("\n");
    } else {
        prt( "\nNo warnings issued.\n\n" ) if (VERB9());
    }
}

sub pgm_exit($$) {
    my ($val,$msg) = @_;
    if (length($msg)) {
        $msg .= "\n" if (!($msg =~ /\n$/));
        prt($msg);
    }
    show_warnings($val);
    ## close_log($outfile,$load_log);
    exit($val);
}


sub prtw($) {
   my ($tx) = shift;
   $tx =~ s/\n$//;
   prt("$tx\n");
   push(@warnings,$tx);
}

sub process_in_file($) {
    my ($inf) = @_;
    if (! open INF, "<$inf") {
        pgm_exit(1,"ERROR: Unable to open file [$inf]\n"); 
    }
    my @lines = <INF>;
    close INF;
    my $lncnt = scalar @lines;
    prt("Processing $lncnt lines, from [$inf]...\n");
    my ($line,$inc,$lnn);
    my @nlines = ();
    my $changes = 0;
    $lnn = 0;
    foreach $line (@lines) {
        chomp $line;
        $lnn++;
        if ($line =~ /\s+\-nodefaultlib\s+/) {
            prt("$lnn: $line\n");
            $line =~ s/\-nodefaultlib\s+//;
            $changes++;
        }
        push(@nlines,$line);
    }
    if ($changes) {
        $lnn = scalar @nlines;
        $line = join("\n",@nlines)."\n";
        prt("Found $changes changes, in $lncnt lines...\n");
        if (length($out_file) == 0) {
            # write to input file
            $inc = rename_2_old_bak($inf);
            if ($inc) {
                if ($inc == 1) {
                    $inc = 'OLD';
                } else {
                    $inc = 'BAK';
                }
                prt("Renamed '$inf' to '$inc'\n");
            }
            write2file($line,$inf);
            prt("Written $lnn lines to $inf...\n");
        } else {
            rename_2_old_bak($out_file);
            write2file($line,$out_file);
            prt("Written $lnn lines to $out_file...\n");
        }
    } else {
        prt("No instance of '-nodefaullib' found in $inf...\n");
        # but if and output file, then must still write that
        if (length($out_file) && ($inf ne $out_file)) {
            $line = join("\n",@nlines)."\n";
            rename_2_old_bak($out_file);
            write2file($line,$out_file);
            prt("Written $lnn lines to $out_file...\n");
        }
    }
}

#########################################
### MAIN ###
parse_args(@ARGV);
process_in_file($in_file);
pgm_exit(0,"");
########################################

sub need_arg {
    my ($arg,@av) = @_;
    pgm_exit(1,"ERROR: [$arg] must have a following argument!\n") if (!@av);
}

sub parse_args {
    my (@av) = @_;
    my ($arg,$sarg);
    my $verb = VERB2();
    while (@av) {
        $arg = $av[0];
        if ($arg =~ /^-/) {
            $sarg = substr($arg,1);
            $sarg = substr($sarg,1) while ($sarg =~ /^-/);
            if (($sarg =~ /^h/i)||($sarg eq '?')) {
                give_help();
                pgm_exit(0,"Help exit(0)");
            } elsif ($sarg =~ /^v/) {
                if ($sarg =~ /^v.*(\d+)$/) {
                    $verbosity = $1;
                } else {
                    while ($sarg =~ /^v/) {
                        $verbosity++;
                        $sarg = substr($sarg,1);
                    }
                }
                $verb = VERB2();
                prt("Verbosity = $verbosity\n") if ($verb);
            #} elsif ($sarg =~ /^l/) {
            #    if ($sarg =~ /^ll/) {
            #        $load_log = 2;
            #    } else {
            #        $load_log = 1;
            #    }
            #    prt("Set to load log at end. ($load_log)\n") if ($verb);
            } elsif ($sarg =~ /^o/) {
                need_arg(@av);
                shift @av;
                $sarg = $av[0];
                $out_file = $sarg;
                prt("Set out file to [$out_file].\n") if ($verb);
            } else {
                pgm_exit(1,"ERROR: Invalid argument [$arg]! Try -?\n");
            }
        } else {
            $in_file = $arg;
            prt("Set input to [$in_file]\n") if ($verb);
        }
        shift @av;
    }

    if ($debug_on) {
        prtw("WARNING: DEBUG is ON!\n");
        if (length($in_file) ==  0) {
            $in_file = $def_file;
            prt("Set DEFAULT input to [$in_file]\n");
        }
    }
    if (length($in_file) ==  0) {
        pgm_exit(1,"ERROR: No input files found in command!\n");
    }
    if (! -f $in_file) {
        pgm_exit(1,"ERROR: Unable to find in file [$in_file]! Check name, location...\n");
    }
}

sub give_help {
    prt("$pgmname: version $VERS\n");
    prt("Usage: $pgmname [options] in-file\n");
    prt("Options:\n");
    prt(" --help  (-h or -?) = This help, and exit 0.\n");
    prt(" --verb[n]     (-v) = Bump [or set] verbosity. def=$verbosity\n");
    ### prt(" --load        (-l) = Load LOG at end. ($outfile)\n");
    prt(" --out <file>  (-o) = Write output to this file.\n");
}

# eof - modmakefile.pl
