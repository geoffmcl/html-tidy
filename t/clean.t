#!/usr/bin/perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 3;

use HTML::Tidy;

my $args = { newline => 'Lf',
    tidy_mark => 0 };
my $tidy = HTML::Tidy->new( $args );
isa_ok( $tidy, 'HTML::Tidy' );

my $expected_pattern = 'Usage: clean($str [, $str...])';
throws_ok {
    $tidy->clean();
} qr/\Q$expected_pattern\E/,
'clean() croaks when not given a string or list of strings';

is(
    $tidy->clean(''),
    _expected_empty_html(),
    '$tidy->clean("") returns empty HTML document',
);

sub _expected_empty_html {
    return <<'ENDHTML';
<!DOCTYPE html>
<html>
<head>
<title></title>
</head>
<body>
</body>
</html>
ENDHTML
}
