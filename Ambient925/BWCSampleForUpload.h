//
//  BWCParseSample.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//
//  Should match the BWCSoundSample object exactly, except for inheritance from NSManagedObject.
//  This class is intended to allow quick transfer of BWCSoundSample details without messing around
//  with Core Data required initializers.
//  IOW, all data held within properties of this class is intended for use with the Parse CloudManager
//  implementation
//
//

#import <Foundation/Foundation.h>

@interface BWCSampleForUpload : NSObject

@property (nonatomic, retain) NSNumber * averageSoundLevel;
@property (nonatomic, retain) NSNumber * peakSoundLevel;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *quotes;

@end
