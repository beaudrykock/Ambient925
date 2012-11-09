//
//  BWCSoundSample.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface BWCSoundSample : NSObject
{

}

@property (nonatomic) float soundLevel; // dB level
@property (nonatomic, retain) NSDate *sampleDate;
@property (nonatomic, retain) CLLocation* sampleLocation;
@property (nonatomic, retain) NSArray *tags; // tags the user may have added for the sample
@property (nonatomic, retain) NSString *soundQuote; // soundquote associated with the dB level

@end
