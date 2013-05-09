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

#import "FSViewController.h"
#import "FSOAuth.h"

@interface FSViewController ()

@property (nonatomic) NSString *latestAccessCode;

@end

@implementation FSViewController

- (void)connectTapped:(id)sender {

    [self dismissKeyboard:nil];
    
    FSOAuthStatusCode statusCode = [FSOAuth authorizeUserUsingClientId:self.clientIdField.text callbackURIString:self.callbackUrlField.text];
    
    NSString *resultText = nil;
    
    switch (statusCode) {
        case FSOAuthStatusSuccess:
            // do nothing
            break;
        case FSOAuthStatusErrorInvalidCallback: {
            resultText = @"Invalid callback URI";
            break;
        }
        case FSOAuthStatusErrorFoursquareNotInstalled: {
            resultText = @"Foursquare not installed";
            break;
        }
        case FSOAuthStatusErrorInvalidClientID: {
            resultText = @"Invalid client id";
            break;
        }
        case FSOAuthStatusErrorFoursquareOAuthNotSupported: {
            resultText = @"Installed FSQ app does not support oauth";
            break;
        }
        default: {
            resultText = @"Unknown status code returned";
            break;
        }
    }
    self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
}

- (NSString *)errorMessageForCode:(FSOAuthErrorCode)errorCode {
    NSString *resultText = nil;
    
    switch (errorCode) {
        case FSOAuthErrorNone: {
            break;
        }
        case FSOAuthErrorInvalidClient: {
            resultText = @"Invalid client error";
            break;
        }
        case FSOAuthErrorInvalidGrant: {
            resultText = @"Invalid grant error";
            break;
        }
        case FSOAuthErrorInvalidRequest: {
            resultText =  @"Invalid request error";
            break;
        }
        case FSOAuthErrorUnauthorizedClient: {
            resultText =  @"Invalid unauthorized client error";
            break;
        }
        case FSOAuthErrorUnsupportedGrantType: {
            resultText =  @"Invalid unsupported grant error";
            break;
        }
        case FSOAuthErrorUnknown:
        default: {
            resultText =  @"Unknown error";
            break;
        }
    }
    
    return resultText;
}

- (void)handleURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"fsoauthexample"]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];;
        
        NSString *resultText = nil;
        if (errorCode == FSOAuthErrorNone) {
            resultText = [NSString stringWithFormat:@"Access code: %@", accessCode];
            self.latestAccessCode = accessCode;
        }
        else {
            resultText = [self errorMessageForCode:errorCode];
        }

        self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
    }
}

- (void)convertTapped:(id)sender {
    
    [self dismissKeyboard:nil];
    
    [FSOAuth requestAccessTokenForCode:self.latestAccessCode
                              clientId:self.clientIdField.text
                     callbackURIString:self.callbackUrlField.text
                          clientSecret:self.clientSecretField.text
                       completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
                           
                           NSString *resultText = nil;
                           if (requestCompleted) {
                               if (errorCode == FSOAuthErrorNone) {
                                   resultText = [NSString stringWithFormat:@"Auth Token: %@", authToken];
                               }
                               else {
                                   resultText = [self errorMessageForCode:errorCode];
                               }
                           }
                           else {
                               resultText = @"An error occurred when attempting to connect to the Foursquare server.";
                           }
                           
                           self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
                       }];
}

- (void)dismissKeyboard:(id)sender {
    [self.clientIdField resignFirstResponder];
    [self.callbackUrlField resignFirstResponder];
    [self.clientSecretField resignFirstResponder];
}

@end
