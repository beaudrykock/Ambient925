//
//  BWCUtilities.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BWCUtilities : NSObject

+(BOOL)appUpgradeAvailable;
+(void)registerForGoogleAnalytics;
+(void)muteUpgradeCheck;
+(BOOL)upgradeCheckAvailable;

@end
