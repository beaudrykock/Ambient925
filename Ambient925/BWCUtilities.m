//
//  BWCUtilities.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCUtilities.h"
#import "OpenUDID.h"
#import "JSONKit.h"
#import "GAI.h"

@implementation BWCUtilities

+(BOOL)upgradeCheckAvailable
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUD_upgradeCheck];
}

+(void)muteUpgradeCheck
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUD_upgradeCheck];
}

+(BOOL)appUpgradeAvailable
{
#ifndef TESTING
    NSString *jsonUrl = @"http://itunes.apple.com/search?term=Ambient925&entity=software&limit=1";
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonUrl]];
    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoderWithParseOptions:JKParseOptionNone];
    NSObject *jsonObject = [jsonKitDecoder objectWithData:jsonData error:nil];
    int results = [[jsonObject valueForKey:@"resultCount"] intValue];
    
    if(results >0) // has results
    {
        NSArray *results = [jsonObject valueForKey:@"results"];
        for(NSObject *aResult in results)
        {
            NSString    *appStoreVersion = [aResult valueForKey:@"version"];
            NSString    *localVersion    = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            if(![appStoreVersion isEqualToString:localVersion])
            {
                return YES;
            }
        }
    }
#endif
    return NO;
}

+(void)registerForGoogleAnalytics
{
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID]; 
    
}

@end
