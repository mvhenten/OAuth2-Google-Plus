use strict;
use warnings;

{
    package OAuth2::Google::Plus::UserInfo;
    use Moo;
    use MooX::late;

    use LWP::UserAgent;
    use JSON qw|decode_json|;
    use Carp::Assert;
    use URI;

    sub ENDPOINT_URL {
        return 'https://www.googleapis.com/oauth2/v2/userinfo';
    }

    has access_token => (
        is         => 'ro',
        isa        => 'Str',
        required   => 1,
    );

    has _user_info => (
        is => 'ro',
        isa => 'HashRef',
        lazy_build => 1,
    );

    sub _build__user_info {
        my ( $self ) = @_;

        my $ua = LWP::UserAgent->new;
        $ua->default_header( Authorization => 'OAuth ' . $self->access_token );

        my $response = $ua->get(ENDPOINT_URL());
        my $json     = decode_json( $response->content );

        return $json;
    }

    sub email {
        my ( $self ) = @_;
        return $self->_user_info->{email};
    }

    sub id {
        my ( $self ) = @_;
        return $self->_user_info->{id};
    }

    sub verified_email {
        my ( $self ) = @_;
        return $self->_user_info->{verified_email};
    }
}

1;
