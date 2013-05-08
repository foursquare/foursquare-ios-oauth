//
//  FSViewController.m
//  FSExampleOAuth
//
//  Created by Brian Dorfman on 4/25/13.
//  Copyright (c) 2013 Foursquare. All rights reserved.
//

#import "FSViewController.h"
#import "FSOAuth.h"

@interface FSViewController ()

@end

@implementation FSViewController

- (void)connectTapped:(id)sender {

    FSOAuthStatusCode statusCode = [FSOAuth authorizeUserUsingClientId:self.clientIdField.text callbackURIString:@"fsoauthexample://authorized"];
    
    switch (statusCode) {
        case FSOAuthStatusSuccess:
            // do nothing
            break;
        case FSOAuthStatusErrorInvalidCallback: {
            self.resultLabel.text = @"Invalid callback URI";
            break;
        }
        case FSOAuthStatusErrorFoursquareNotInstalled: {
            self.resultLabel.text = @"Foursquare not installed";
            break;
        }
        case FSOAuthStatusErrorInvalidClientID: {
            self.resultLabel.text = @"Invalid client id";
            break;
        }
        case FSOAuthStatusErrorFoursquareOAuthNotSupported: {
            self.resultLabel.text = @"Installed FSQ app does not support oauth";
            break;
        }
        default: {
            self.resultLabel.text = @"Unknown status code returned";
            break;
        }
    }
}

- (void)handleURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"fsoauthexample"]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];;
        
        switch (errorCode) {
            case FSOAuthErrorNone: {
                self.resultLabel.text = [NSString stringWithFormat:@"Access code: %@", accessCode];
                break;
            }
            case FSOAuthErrorInvalidClient: {
                self.resultLabel.text = @"Invalid client error";
                break;
            }
            case FSOAuthErrorInvalidGrant: {
                self.resultLabel.text = @"Invalid grant error";
                break;
            }
            case FSOAuthErrorInvalidRequest: {
                self.resultLabel.text =  @"Invalid request error";
                break;
            }
            case FSOAuthErrorUnauthorizedClient: {
                self.resultLabel.text =  @"Invalid unauthorized client error";
                break;
            }
            case FSOAuthErrorUnsupportedGrantType: {
                self.resultLabel.text =  @"Invalid unsupported grant error";
                break;
            }
            default: {
                self.resultLabel.text =  @"Unknown error";
                break;
            }
        }
    }
}

- (void)convertTapped:(id)sender {
#warning work in progress
}

@end
