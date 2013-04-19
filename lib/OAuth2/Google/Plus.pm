use strict;
use warnings;

=NAME

=SYNOPSYS

    use OAuth2::Google::Plus;

    my $plus = OAuth2::Google::Plus->new(
        client_id       => 'CLIENT ID',
        client_secret   => 'CLIENT SECRET',
        redirect_uri    => 'http://my.app.com/authorize',
    );

    # generate the link for signup
    my $uri = $plus->authorization_uri( redirect_url => $url_string )

    # callback returns with a code in url
    my $access_token = $plus->authorize( $request->param('code') );

    # store $access_token somewhere safe...

    # use $authorization_token
    my $info = OAuth2::Google::Plus::UserInfo->new( access_token => $access_token );

=cut


{
    package OAuth2::Google::Plus;
    use Moo;
    use MooX::late;

    use Carp::Assert;
    use JSON qw|decode_json|;
    use LWP::UserAgent;
    use URI;

    sub ENDPOINT_URL {
        return 'https://accounts.google.com/o/oauth2';
    }

    has client_id => (
        is      => 'ro',
        isa     => 'Str',
        required => 1,
    );

    has client_secret => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    has scope => (
        is       => 'ro',
        isa      => 'Str',
        default  => 'https://www.googleapis.com/auth/userinfo.email',
        required => 1,
    );

    has redirect_uri => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    sub authorization_uri {
        my ( $self ) = @_;

        my $uri = URI->new( ENDPOINT_URL() . '/auth' );

        $uri->query_form(
            access_type     => 'offline',
            approval_prompt => 'force',
            client_id       => $self->client_id,
            redirect_uri    => $self->redirect_uri,
            response_type   => 'code',
            scope           => $self->scope,
        );

        return $uri;
    }

    sub authorize {
        my ( $self, %params ) = @_;

        assert( $params{authorization_code}, 'missing named argument "authorization_code"');

        my $uri = URI->new( OAuth2::Google::Plus::ENDPOINT_URL() . '/token' );
        my $ua  = LWP::UserAgent->new;

        my $response = $ua->post( $uri, {
            client_id       => $self->client_id,
            client_secret   => $self->client_secret,
            code            =>  $params{authorization_code},
            grant_type      => 'authorization_code',
            redirect_uri    => $self->redirect_uri,
            scope           => $self->scope,
        });

        my $json     = decode_json( $response->content );
        return $json->{access_token};
    }
}

1;
