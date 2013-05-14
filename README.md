foursquare-ios-oauth
====================

Foursquare native auth makes it easier for users of your app to connect to Foursquare. If the user already has Foursquare installed on their device, it will use their existing credentials from the app instead of presenting the user with another login screen.

This repo includes a helper class (FSOAuth) that can be used as-is in your own app. It also includes a simple test application as an example of how to use the class.


Setting up FSOAuth with your app
=================================

1. Enter your app's callback URL at http://foursquare.com/developers/apps in the "Redirect URI(s)" field (you can add multiple URI's in this field, if you already have another one just separate them with a comma)

2. Add your callback URL scheme to your app's Info.plist (under the URL types field).

3. Add FSOAuth.h/m into your Xcode project. If you are using git for version control in your app, we recommend adding this repo as a submodule to yours to make it easier to get future updates.


Using FSOAuth
=============

FSOAuth has three primary methods.

```objc
+ (FSOAuthStatusCode)authorizeUserUsingClientId:(NSString *)clientID callbackURIString:(NSString *)callbackURIString;
```
Call this method with your app's client ID and callback string to authorize a user with Foursquare. If a current version of the Foursquare app is installed, it will bounce the user out to that app and present them with an authorization dialog. After the user chooses Accept or Deny, your app will receive a callback at the url specified with the accessCode for the user attached. 

Note: Your callback _MUST_ be added to the "Redirect URI(s)" field at http://foursquare.com/developers/apps or users will see an error message instead of the authorization prompt.

There are five possible return values from this method:

FSOAuthStatusSuccess
--------------------
The OAuth request was successfully initiated. The user has been bounced out to the Foursquare iOS app to approve or deny authorizing your app.

FSOAuthStatusErrorInvalidClientID
---------------------------------
You did not provide a valid client ID to the method.

FSOAuthStatusErrorInvalidCallback
---------------------------------
You did not provide a valid callback string that has been registered with the system.

FSOAuthStatusErrorFoursquareNotInstalled
----------------------------------------
Foursquare is not installed on the user's iOS device. They have been bounced out to the Foursquare app page on the App Store.

FSOAuthStatusErrorFoursquareOAuthNotSupported
---------------------------------------------
The version of the Foursquare app installed on the user's iOS device is too old to support native auth. They have been bounced out to the Foursquare app page on the App Store.


```objc
+ (NSString *)accessCodeForFSOAuthURL:(NSURL *)url error:(FSOAuthErrorCode *)errorCode;
```

Call this method when you receive the callback from Foursquare, passing in the NSURL object your received. It will parse out the access code and error code (if any) from the URL's parameters and return them to you.

The possible error code values are:

FSOAuthErrorNone
----------------
There was no error and the access code was read successfully.

FSOAuthErrorUnknown
-------------------
An unrecognized error string was returned from the Foursquare server or the URL could not be parsed properly

FSOAuthErrorInvalidRequest / FSOAuthErrorInvalidClient / FSOAuthErrorInvalidGrant / FSOAuthErrorUnauthorizedClient / FSOAuthErrorUnsupportedGrantType
----------------------------
These enumeration values correspond to the OAuth error codes listed at http://tools.ietf.org/html/rfc6749#section-5.2

```objc
+ (void)requestAccessTokenForCode:(NSString *)accessCode
		                 clientId:(NSString *)clientID
		        callbackURIString:(NSString *)callbackURIString
	                 clientSecret:(NSString *)clientSecret
		          completionBlock:(FSTokenRequestCompletionBlock)completionBlock;
```

This method will initiate an asynchronous network request to the Foursquare token to convert a user's access code into an auth token.

*WARNING:* For security reasons, it is recommended that you not use this method if possible. You should pass the returned accessCode to your own server and have it contact the Foursquare server to convert the code to an access token instead of including your client secret in your app's binary. However, this helper method is provided for you to use if this is not possible for your app.

Call this method with the access code returned to you by accessCodeForFSOAuthURL:error: along with your app's Foursquare client ID, callback string, and client secret. The callback URI must be the same one that was used to generate the access code.

When the network request completes, your completion block will be called. The block has the following signature

```objc
typedef void (^FSTokenRequestCompletionBlock)(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode);
```

_authToken_ will be set to the Foursquare OAuth token for the user if the request succeeded. 

_errorCode_ is an error code from the Foursquare server. It has the same possible values as the errorCode from accessCodeForFSOAuthURL:error: (see above)

_requestCompleted_ will be YES if the network request actually completed properly or NO if it did not. If this is NO, the values of _authToken_ and _errorCode_ should be ignored.





See https://developer.foursquare.com for more information on how to use the Foursquare API. 
