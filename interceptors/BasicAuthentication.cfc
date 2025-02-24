component{
	/**
	* If a Basic authentication header exists, attempts to log the user in.
	* If the credentials are invalid, logs any currently logged in user out.
	**/
	void function onRequestCapture( event, rc, prc, interceptData, buffer ) {
        var authorization = event.getHTTPHeader( "Authorization", "" );

        if ( ! len( authorization ) || listFirst( authorization, " " ) != 'Basic' ) { return; }

        try{
            var credentials = listToArray( toString( toBinary( listLast( authorization, " " ) ) ), ":" );

            if( credentials.len() != 2 ){ return; }

            auth().authenticate( credentials[ 1 ], credentials[ 2 ] );

            prc.authenticationMethod = "basic";

        }  catch ( InvalidCredentials e ) {
            event.overrideEvent( "WEATPublicSecurityAPIv1:Authentication.onAuthenticationFailure" );
        } catch( any e ){
            // skip out and let subsequent interceptions handle the auth failure
            return;
        }
    }
}