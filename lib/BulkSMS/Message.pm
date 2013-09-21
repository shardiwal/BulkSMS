package BulkSMS::Message;

use Moose;
use BulkSMS::Util;

use LWP::UserAgent;

=head1 NAME

BulkSMS::Message

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

has 'receiver_mobile_no' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => 1
);

has 'message' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has 'sms_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        return BulkSMS::Util::base_url . "/web2sms.php";
    }
);

has 'delivery_status_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        return BulkSMS::Util::base_url . "/status.php";
    }
);

has 'user' => (
    is       => 'ro',
    isa      => 'BulkSMS::User',
    required => 1
);

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use BulkSMS::Message;

    my $message = BulkSMS::Message->new(
        user                => $user,
        receiver_mobile_no  => [ 'mobile no 1', 'mobile no 2' ],
        message             => "wow this is working"
    );
    $message->send();

=head1 SUBROUTINES/METHODS

=head2 send

=cut

sub send {
    my ($self) = @_;
    if ( $self->user ) {
        $self->_send_message();
    }
    else {
        BulkSMS::Util::inform_user(" User Login failed ");
    }
}

sub _send_message {
    my ($self) = @_;
    my $browser = $self->user->browser;
    my $mobile_nos = join( ',', @{ $self->receiver_mobile_no } );
    my $smsrequest = $browser->request(
        HTTP::Request->new(
            GET => BulkSMS::Util::prepare_uri_as_string(
                $self->sms_url,
                [
                    workingkey    => $self->user->api_key,
                    sender        => $self->user->senderid,
                    message       => $self->message,
                    to            => $mobile_nos
                ]
            )
        )
    );
    if ( $smsrequest->decoded_content =~ /\d+/ ) {
        my $delivery_status =
          $self->delivery_report( $smsrequest->decoded_content );
        BulkSMS::Util::inform_user(
            "Message sent to : $mobile_nos and it has been $delivery_status.");
        return 1;
    }
    else {
        BulkSMS::Util::inform_user( "Message sending failed to $mobile_nos : "
              . $smsrequest->decoded_content );
        return 0;
    }
}

sub delivery_report {
    my ( $self, $message_id ) = @_;
    my $browser                 = $self->user->browser;
    my $delivery_status_request = $browser->request(
        HTTP::Request->new(
            GET => BulkSMS::Util::prepare_uri_as_string(
                $self->delivery_status_url, [ 
                    messageid  => $message_id, 
                    workingkey => $self->user->api_key
                ]
            )
        )
    );
    return $delivery_status_request->decoded_content;
}

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BulkSMS::Message

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

no Moose;
__PACKAGE__->meta->make_immutable();

1;    # End of BulkSMS::Message
