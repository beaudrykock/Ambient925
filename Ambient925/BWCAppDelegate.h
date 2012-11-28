//
//  BWCAppDelegate.h
//  Ambient925
//
//  Created by Beaudry Kock on 10/28/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWCReachability.h"
#import "BWCSoundSampler.h"
#import <FacebookSDK/FacebookSDK.h>

@interface BWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) BWCReachability *reachabilityNotififier;
- (void)openSession;
@end
