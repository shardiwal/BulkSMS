#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib';

use BulkSMS::User;
use BulkSMS::Message;

my $user = BulkSMS::User->new(
    api_key   => 'api_key',
    senderid  => 'Demo'
);

# To check Credits
print $user->balance();

# To send message
my $message = BulkSMS::Message->new(
    user                => $user,
    receiver_mobile_no  => [ '91xxxxxxxxxx', '91xxxxxxxxxx' ],
    message             => 'This is a test from BulkSMS perl API.'
);
$message->send();

# To Check the Delivery reports
print $message->delivery_report( 'message_id' );


