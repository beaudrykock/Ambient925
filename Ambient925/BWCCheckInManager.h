//
//  BWCCheckInManager.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//
/*
 * Purpose of this class is to handle the back-end of approved social network and Parse checkins
 * 
 *
 *
 */

#import <Foundation/Foundation.h>
#import "BWCSampleForUpload.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface BWCCheckInManager : NSObject

+(BWCCheckInManager*) sharedInstance;

// PUBLIC
-(void)checkInSample:(BWCSampleForUpload*)sample overChannels:(NSArray*)channels withTags:(NSMutableArray *)tags andComment:(NSString*)string;

@end
