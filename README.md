foursquare-ios-oauth
====================

Foursquare native authentication makes it easier for your app's users to connect with Foursquare. Unlike web-based OAuth, native authentication re-uses the Foursquare app's user credentials, saving users the hassle of re-logging in to Foursquare within your app.

This repo includes a helper class (`FSOAuth`) that can be used as-is in your own app. It also includes a simple test application as an example of how to use the class.


Setting up FSOAuth with your app
=================================

1. Enter your app's custom URL scheme callback (e.g. yourappname://foursquare) at [http://foursquare.com/developers/apps](http://foursquare.com/developers/apps) in the "Redirect URI(s)" field. You can add multiple URIs in this field; separate them with commas.

2. Add your callback URL scheme to your app's `Info.plist` file (in the URL types field).

3. Add `FSOAuth.{h,m}` to your Xcode project. If you are using git for version control in your app, we recommend adding this repo as a submodule to yours to make it easier to get future updates. FSOAuth can be added to a project using [CocoaPods](https://github.com/cocoapods/cocoapods).


Using FSOAuth
=============

FSOAuth has three primary methods.

```objc
+ (FSOAuthStatusCode)authorizeUserUsingClientId:(NSString *)clientID callbackURIString:(NSString *)callbackURIString;
```
Call this method with your app's client ID and callback string to authorize a user with Foursquare. If a current version of the Foursquare app is installed, it will bounce the user out to that app and present them with an authorization dialog. After the user chooses Accept or Deny, your app will receive a callback at the url specified with the accessCode for the user attached. 

Note: Your callback _MUST_ be added to the "Redirect URI(s)" field at [http://foursquare.com/developers/apps](http://foursquare.com/developers/apps) or users will see an error message instead of the authorization prompt.

This method has five possible return values:

* **FSOAuthStatusSuccess** The OAuth request was successfully initiated. The user has been bounced out to the Foursquare iOS app to approve or deny authorizing your app.
* **FSOAuthStatusErrorInvalidClientID** You did not provide a valid client ID to the method.
* **FSOAuthStatusErrorInvalidCallback** You did not provide a valid callback string that has been registered with the system.
* **FSOAuthStatusErrorFoursquareNotInstalled** Foursquare is not installed on the user's iOS device. They have been bounced out to the Foursquare app page on the App Store.
* **FSOAuthStatusErrorFoursquareOAuthNotSupported** The version of the Foursquare app installed on the user's iOS device is too old to support native auth. They have been bounced out to the Foursquare app page on the App Store.

```objc
+ (NSString *)accessCodeForFSOAuthURL:(NSURL *)url error:(FSOAuthErrorCode *)errorCode;
```

Call this method when you receive the callback from Foursquare, passing in the `NSURL` object you received. It will parse out the access code and error code (if any) from the URL's parameters and return them to you.

The possible error code values are:

* **FSOAuthErrorNone** There was no error and the access code was read successfully.
* **FSOAuthErrorUnknown** An unrecognized error string was returned from the Foursquare server or the URL could not be parsed properly
* **FSOAuthErrorInvalidRequest** / **FSOAuthErrorInvalidClient** / **FSOAuthErrorInvalidGrant** / **FSOAuthErrorUnauthorizedClient** / **FSOAuthErrorUnsupportedGrantType** - These enumeration values correspond to the OAuth error codes listed at [http://tools.ietf.org/html/rfc6749#section-5.2](http://tools.ietf.org/html/rfc6749#section-5.2).

```objc
+ (void)requestAccessTokenForCode:(NSString *)accessCode
		                 clientId:(NSString *)clientID
		        callbackURIString:(NSString *)callbackURIString
	                 clientSecret:(NSString *)clientSecret
		          completionBlock:(FSTokenRequestCompletionBlock)completionBlock;
```

This method will initiate an asynchronous network request to Foursquare to convert a user's access code into an auth token.

*WARNING:* For security reasons, it is recommended that you not use this method if possible. You should pass the returned accessCode to your own server and have it contact the Foursquare server to [convert the code to an access token](https://developer.foursquare.com/overview/auth#code) instead of including your client secret in your app's binary. However, this helper method is provided for you to use if this is not possible for your app.

Call this method with the access code returned to you by `+accessCodeForFSOAuthURL:error:` along with your app's Foursquare client ID, callback string, and client secret. The callback URI must be the same one that was used to generate the access code.

When the network request completes, your completion block will be called. The block has the following signature:

```objc
typedef void (^FSTokenRequestCompletionBlock)(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode);
```

_authToken_ will be set to the Foursquare OAuth token for the user if the request succeeded. 

_errorCode_ is an error code from the Foursquare server. It has the same possible values as the errorCode from `+accessCodeForFSOAuthURL:error:`. (See above.)

_requestCompleted_ will be `YES` if the network request actually completed properly or `NO` if it did not. If this is `NO`, the values of _authToken_ and _errorCode_ should be ignored. If `NO`, you may want to re-try the request again after checking that the user has a valid internet connection. This could also indicate a temporary problem with the Foursquare servers.

Using the example application
=============================

The example application can be used as a simple reference for how to use the FSOAuth in your class, as well as a basic test to make sure your client id and secret is working properly.

The app will present you with fields to enter your client id, client secret, and callback URL. It has two buttons. The first initates the fast app switch to the Foursquare app and gets the access code. The second converts a received access code to a token by contacting the Foursquare servers. This will only work after first successfully receiving an access code from the initial Foursquare fast app switch.

The app itself uses "fsoauthexample" as its schema. If you want to be redirected back to it after the fast app switch (instead of to your own app) you will need to add an fsoauthexample redirect URI to your app's settings on foursquare.com (or change the `Info.plist` and `FSViewController.m`'s `-handleURL:` method to match one of your existing redirect schemas). This is necessary for the code → token conversion functionality to work.

You should hard code all these values in your own application. Your client secret should be stored only on your own server, if possible, and not included in the app at all.

More Information
================
See [https://developer.foursquare.com](https://developer.foursquare.com) for more information on how to use the Foursquare API.
