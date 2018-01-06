#!/usr/bin/perl -w
use strict;
use warnings;
use HTML::Tidy;
my $PATH_SEP =  '/';
my $shext = 'so';
if ($^O =~ /win/i) {
    $PATH_SEP = "\\";
    $shext = 'dll';
}
my $use_conf_file = 1;
my $tp = $PATH_SEP.'HTML'.$PATH_SEP.'Tidy.pm';
my $ta = $PATH_SEP.'auto'.$PATH_SEP.'HTML'.$PATH_SEP.'Tidy'.$PATH_SEP.'Tidy.'.$shext;
my ($tidy,$cnt,$path,$ok,$test1,$test2);
$cnt = scalar @INC;
print "\@INC contains $cnt paths...\n";
$cnt = 0;
foreach $path (@INC) {
    $cnt++;
    $test1 = $path.$tp;
    $test2 = $path.$ta;
    if (-f $test1) {
        $path .= " - $tp";
    }
    if (-f $test2) {
        $path .= " - $ta";
    }
    print "$cnt: $path\n";
}
if ($use_conf_file) {
    #my $txt = "show-body-only: 1\ntidy-mark: 0\n";
    my $txt = "indent: 1\nwrap: 0\nshow-info: 0\n";
    my $file = 'temptidy.cfg';
    open WOF, ">$file" or die "ERROR: Unable to open $file! $!\n";
    print WOF $txt;
    close WOF;
    $tidy = HTML::Tidy->new( {'config_file' => $file} );
} else {
    #my $args = { show_body_only => 1,
    #    show_info => 0 };
    my $args = { indent => 1,
        wrap => 0,
        tidy_mark => 0,
        show_info => 0 };
    $tidy = HTML::Tidy->new( $args );
}
if (! $tidy) {
    die "ERROR: Failed to load HTML::Tidy ... $! ...\n";
}
my $vers = $tidy->tidyp_version();
if ($vers) {
    print "Using version $vers\n";
}
my $doc = <<"EOF;";
 <p>Hello Tidy!</p>
EOF;
#my $rc = $tidy->parse( '-', $doc );
#print "$clean\n";
my $clean = $tidy->clean( $doc );
print "$clean\n";
my @msg = $tidy->messages();
if (@msg) {
    my $cnt = scalar @msg;
    print "Have $cnt messages...\n";
    print join("\n",@msg)."\n";
}
# tidy04.pl - eof

