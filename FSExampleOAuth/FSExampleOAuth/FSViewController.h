//
//  FSViewController.h
//  FSExampleOAuth
//
//  Created by Brian Dorfman on 4/25/13.
//  Copyright (c) 2013 Foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)authorizeTapped:(id)sender;
- (void)handleURL:(NSURL *)url;

@end
