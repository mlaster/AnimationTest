//
//  AnimationTestViewController.m
//  AnimationTest
//
//  Created by Mike Laster on 5/17/11.
//  Copyright 2011 Apple, Inc. All rights reserved.
//

#import "AnimationTestViewController.h"
#import "FMPinCaptureViewController.h"

@implementation AnimationTestViewController

- (void)viewDidAppear:(BOOL)animated {
    FMPinCaptureViewController *vc = nil;

    vc = [[[FMPinCaptureViewController alloc] init] autorelease];
    [vc setMode:FMModeLockSet];
    
    [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.view.window.rootViewController presentModalViewController:vc animated:YES];

    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
