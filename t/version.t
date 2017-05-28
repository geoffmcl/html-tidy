#!perl -T

use warnings;
use strict;

use Test::More tests => 2;

use HTML::Tidy;

for my $version_string (HTML::Tidy->tidyp_version, HTML::Tidy->libtidyp_version) {
    like( $version_string, qr/^\d\.\d\.\d/, 'Valid version string' );
    # cmp_ok( $version_string, '>=', '0.90', 'Version is greater than 0.90, which is the one I maintain' );
}
