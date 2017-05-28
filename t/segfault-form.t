#!perl -Tw

use strict;
use warnings;
use Test::More tests => 3;

use HTML::Tidy;
my $html = do { local $/ = undef; <DATA>; };

my $args = { force_output => 1 };
my $tidy = HTML::Tidy->new( $args );
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->clean( $html );
isa_ok( $tidy, 'HTML::Tidy' );
pass( 'Cleaned OK' );

__DATA__
<form action="http://www.alternation.net/cobra/index.pl">
<td><input name="random" type="image" value="random creature" src="http://www.creaturesinmyhead.com/images/random.gif"></td>
</form>
