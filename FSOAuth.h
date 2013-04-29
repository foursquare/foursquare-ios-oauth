//
//  FSOAuth.h
//  FSSampleOAuth
//
//  Created by Brian Dorfman on 4/22/13.
//  Copyright (c) 2013 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FSOAuthStatusCode) {
    FSOAuthStatusSuccess,                           // Sucessfully initiated the OAuthRequest
    FSOAuthStatusErrorInvalidClientID,              // An invalid clientId was passed in
    FSOAuthStatusErrorInvalidCallback,              // An invalid callbackUrl was passed in
    FSOAuthStatusErrorFoursquareNotInstalled,       // The Foursquare app is not installed on the user's device
    FSOAuthStatusErrorFoursquareOAuthNotSupported,  // The Foursquare app is installed, but it is not a new enough version to support OAuth
};

// See http://tools.ietf.org/html/rfc6749#section-5.2
typedef NS_ENUM(NSUInteger, FSOAuthErrorCode) {
    FSOAuthErrorNone,                           
    FSOAuthErrorInvalidRequest,
    FSOAuthErrorInvalidClient,
    FSOAuthErrorInvalidGrant,
    FSOAuthErrorUnauthorizedClient,
    FSOAuthErrorUnsupportedGrantType
};

@interface FSOAuth : NSObject

/**
 Attempt to initiate OAuth request by bouncing user out to the native iOS Foursquare app.
 
 May return with an error code if passed in parameters are invalid. 
 Will launch into the Foursquare page on the App Store if Foursquare is not installed or outdated.
 */
+ (FSOAuthStatusCode)authorizeUserUsingClientId:(NSString *)clientID callbackURIString:(NSString *)callbackURIString;

/**
 Given the OAuth response URL, will return the access code for the authorized user, or nil if there was an error in authorization.
 
 For security reasons, it is recommended that you pass the returned accessCode to your own server and have it convert the code to 
 an access token using your secret key instead of including your client secret in your app's binary
 
 You can optionally pass in a FSOAuthErrorCode pointer to have it set to the error (if any) on return (or pass NULL)
 */
+ (NSString *)accessCodeForFSOAuthURL:(NSURL *)url error:(FSOAuthErrorCode *)errorCode;


@end
