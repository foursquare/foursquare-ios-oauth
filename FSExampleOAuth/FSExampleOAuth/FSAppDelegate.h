//
//  FSAppDelegate.h
//  FSExampleOAuth
//
//  Created by Brian Dorfman on 4/25/13.
//  Copyright (c) 2013 Foursquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSViewController;

@interface FSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FSViewController *viewController;

@end
