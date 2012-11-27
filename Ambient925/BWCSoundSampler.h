//
//  BWCSoundSampler.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BWCSoundSample.h"
#import "BWCSoundQuote.h"
#import "BWCSoundTag.h"
#import "BWCLocationManager.h"

@interface BWCSoundSampler : NSObject <AVAudioRecorderDelegate>
{

}

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) AVAudioRecorder *sampler;
@property (nonatomic, retain) NSTimer *sampleTimer;

+(BWCSoundSampler*) sharedInstance;
- (void)levelTimerCallback:(NSTimer *)timer;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
