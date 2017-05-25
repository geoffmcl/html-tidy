#!perl -T

use warnings;
use strict;

use Test::More tests => 2;

use HTML::Tidy;

my $filename = 't/venus.html';
open( my $fh, '<', $filename ) or die "Can't open $filename: $!\n";
my $raw = do { local $/ = undef; <$fh> };
close $fh;

my $cfg = 't/venus.cfg';
my $tidy = HTML::Tidy->new( {config_file => $cfg} );
isa_ok( $tidy, 'HTML::Tidy' );

my $cooked = $tidy->clean( $raw );
my @cooked = split( /\n/, $cooked );
chomp @cooked;

my @expected = <DATA>;
chomp @expected;
is_deeply( \@cooked, \@expected, 'Cooked stuff looks like what we expected' );

__DATA__
<html>
  <head>
    <meta name="GENERATOR" content="Adobe PageMill 3.0 Mac" />
    <title>Venus Flytrap for 100 Question</title>
    <style type="text/css">
 body {
  background-image: url(../../WetlandGraphics/PaperBG.gif);
  background-color: #FFFFFF;
 }
 :link { color: #5B3D23 }
 :visited { color: #BE844A }
 :active { color: #8C6136 }
 span.c3 {color: #ED181E}
 h1.c2 {color: #ED181E}
 div.c1 {text-align: center}
</style>
  </head>
  <body>
    <div class="c1">
      <h1>
        <img src="../../WetlandGraphics/KildeerLogo2.gif" width="345"
        height="21" align="bottom" border="0" />
      </h1>
    </div>
    <div class="c1">
      <h1>Wetland Plants Jeopardy</h1>
    </div>
    <div class="c1">
      <h1 class="c2">Venus Flytrap for 100</h1>
    </div>
    <div class="c1">
      <h1>
        <img src="ST100.gif" width="100" height="101" align="bottom" />
      </h1>
    </div>
    <p> </p>
    <div class="c1">
      <h2>
      <span class="c3">Question:</span> What does the Venus Flytrap feed
      on?</h2>
    </div>
    <div class="c1">
      <h4>
        <a href="Venus100Ans.html">Click here for the answer.</a>
      </h4>
    </div>
    <div class="c1">
      <h4>
        <img src="../../WetlandGraphics/GoldbarThread.gif" width="648"
        height="4" align="bottom" />
      </h4>
    </div>
    <div class="c1">
      <h4>| 
      <a href="../../General/Map.html">Map</a> | 
      <a href="../../General/SiteSearch.html">Site Search</a> | 
      <a href="../../General/Terms.html">Terms</a> | 
      <a href="../../General/Credits.html">Credits</a> | 
      <a href="../../General/Feedback.html">Feedback</a> |</h4>
    </div>
    <address>
      <div class="c1">
        <p>
          <img src="../../WetlandGraphics/GoldbarThread.gif" width="648"
          height="4" align="bottom" />
        </p>
      </div>
      <div align="center"></div>
      <address>
        <div class="c1">
          <address>Created for the Museums in the Classroom program sponsored
          by Illinois State Board of Education, the Brookfield Zoo, the
          Illinois State Museum., and Kildeer Countryside CCSD 96.</address>
          <address> </address>
          <address>Authors: Twin Groves Museums in the Classroom
          Team,</address>
          <address>School: Twin Groves Junior High School, Buffalo Grove,
          Illinois 60089</address>
        </div>
      </address>
      <address>
        <div class="c1">Created: 27 June 1998- Updated: 6 October 2003</div>
      </address>
    </address>
  </body>
</html>
