//
// Copyright 2013 Foursquare
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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


/**
 Given an access code, will request an auth token from the Foursquare servers.
 
 For security reasons, it is recommended that you pass the returned accessCode to your own server and have it convert the code to
 an access token using your secret key instead of including your client secret in your app's binary
 
 You can optionally pass in a FSOAuthErrorCode pointer to have it set to the error (if any) on return (or pass NULL)
 */
+ (void)accessTokenForCode:(NSString *)accessCode clientId:(NSString *)clientID callbackURIString:(NSString *)callbackURIString clientSecret:(NSString *)clientSecret error:(FSOAuthErrorCode *)errorCode;

@end
