//
//  BWCSoundSampler.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCSoundSampler.h"

@implementation BWCSoundSampler

+ (BWCSoundSampler *)sharedInstance
{
    static BWCSoundSampler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BWCSoundSampler alloc] init];
    });
    return sharedInstance;
}

@end
