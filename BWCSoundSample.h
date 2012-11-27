//
//  BWCSoundSample.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BWCSoundQuote, BWCSoundTag;

@interface BWCSoundSample : NSManagedObject

@property (nonatomic, retain) NSNumber * averageSoundLevel;
@property (nonatomic, retain) NSNumber * peakSoundLevel;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *quotes;
@end

@interface BWCSoundSample (CoreDataGeneratedAccessors)

- (void)addTagsObject:(BWCSoundTag *)value;
- (void)removeTagsObject:(BWCSoundTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addQuotesObject:(BWCSoundQuote *)value;
- (void)removeQuotesObject:(BWCSoundQuote *)value;
- (void)addQuotes:(NSSet *)values;
- (void)removeQuotes:(NSSet *)values;

@end
