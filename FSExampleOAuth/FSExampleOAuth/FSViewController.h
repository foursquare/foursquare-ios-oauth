//
//  FSViewController.h
//  FSExampleOAuth
//
//  Created by Brian Dorfman on 4/25/13.
//  Copyright (c) 2013 Foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *clientIdField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *clientSecretField;
@property (weak, nonatomic) IBOutlet UILabel *tokenResultLabel;


- (IBAction)connectTapped:(id)sender;
- (IBAction)convertTapped:(id)sender;

- (void)handleURL:(NSURL *)url;

@end
