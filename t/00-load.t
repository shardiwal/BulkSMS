#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'BulkSMS' ) || print "Bail out!\n";
}

diag( "Testing BulkSMS $BulkSMS::VERSION, Perl $], $^X" );
