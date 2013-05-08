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
