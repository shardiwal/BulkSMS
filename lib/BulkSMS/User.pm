package BulkSMS::User;

use Moose;
use BulkSMS::Util;

=head1 NAME

BulkSMS::User

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

has 'api_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'senderid' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'browser' => (
    is      => 'ro',
    isa     => 'LWP::UserAgent',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        my $browser = LWP::UserAgent->new;
        $browser->cookie_jar( {} );
        return $browser;
    }
);

has 'balance_check_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        return BulkSMS::Util::base_url . "/credits.php";
    }
);

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use BulkSMS::Message;

    my $user = BulkSMS::User->new(
        api_key   => $api_key,
        senderid   => $sender_id
    );

=head1 SUBROUTINES/METHODS

=head2 check_balance

=cut

sub balance {
    my ($self) = @_;
    my $smsrequest = $self->browser->request(
        HTTP::Request->new(
            GET => BulkSMS::Util::prepare_uri_as_string(
                $self->balance_check_url,
                [
                    workingkey => $self->api_key
                ]
            )
        )
    );
    return $smsrequest->decoded_content;
}

=head1 AUTHOR

Rakesh Kumar Shardiwal, C<< <rakesh.shardiwal at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BulkSMS::User

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Rakesh Kumar Shardiwal.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

no Moose;
__PACKAGE__->meta->make_immutable();

1;    # End of BulkSMS::User
