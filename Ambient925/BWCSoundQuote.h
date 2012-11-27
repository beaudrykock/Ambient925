//
//  BWCSoundQuote.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BWCSoundSample;

@interface BWCSoundQuote : NSManagedObject

@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) BWCSoundSample *sample;

@end
