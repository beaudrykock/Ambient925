//
//  BWCAppDelegate.h
//  Ambient925
//
//  Created by Beaudry Kock on 10/28/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWCReachability.h"

@interface BWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) BWCReachability *reachabilityNotififier;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
