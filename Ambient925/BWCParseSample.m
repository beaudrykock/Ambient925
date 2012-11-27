//
//  BWCParseSample.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCParseSample.h"

@implementation BWCParseSample

-(NSString*)description
{
    return [NSString stringWithFormat:@"Average sound level: %f\nPeak sound level: %f\nInterval: %f\nDate: %@", self.averageSoundLevel.floatValue, self.peakSoundLevel.floatValue, self.interval.floatValue, self.date.description];
}

@end
