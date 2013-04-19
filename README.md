## OAuth2::Google::Plus

Perl module that implements the OAuth2 API from google.

## SYNOPSIS

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

## TODO

Currently this module only implements the userinfo endpoint. 
