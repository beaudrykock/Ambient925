//
//  BWCAppDelegate.m
//  Ambient925
//
//  Created by Beaudry Kock on 10/28/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCAppDelegate.h"

@implementation BWCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [BWCUtilities registerForGoogleAnalytics];
    [BWCUtilities launchCloud];
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    if ([BWCUtilities appUpgradeAvailable] && [BWCUtilities upgradeCheckAvailable])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update available" message:@"A newer version of this app is available. Please upgrade in the App Store" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alertView show];
    }
    
    // start reachability notifier - will post notification when internet reachability changes
    // subscribe to kInternetReachable... notifications for access
    self.reachabilityNotififier = [[BWCReachability alloc] init];
    
    return YES;
}

// clears the upgrade check so users aren't bugged repeatedly if they close the alert
-(void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Update available"])
    {
        [BWCUtilities muteUpgradeCheck];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[BWCSoundSampler sharedInstance] saveContext];
}

@end
