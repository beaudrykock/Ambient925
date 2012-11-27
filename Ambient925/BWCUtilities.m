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

+(BOOL)sampleUploadIntervalExceeded
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kUP_lastSampleUploadDate];
    
    if (date==NULL)
    {
        return YES;
    }
    else
    {
        NSDate *now = [NSDate date];
        if (abs([now timeIntervalSinceReferenceDate]-[date timeIntervalSinceReferenceDate])>kSampleUploadInterval)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+(void)sampleUploaded
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kUP_lastSampleUploadDate];
}

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

+(void)launchCloud
{
    // automatic user tracking is enabled from the start, which means
    // sound samples can be associated with the user without the user
    // having to login; if/when the user does want an account, this
    // is then automatically associated with the PFUser object
    
    [Parse setApplicationId:kParseApplicationID clientKey:kParseClientKey];
    [PFUser enableAutomaticUser];
}

@end
