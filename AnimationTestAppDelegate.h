//
//  AnimationTestAppDelegate.h
//  AnimationTest
//
//  Created by Mike Laster on 5/17/11.
//  Copyright 2011 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimationTestViewController;

@interface AnimationTestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AnimationTestViewController *viewController;

@end
