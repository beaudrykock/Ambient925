//
//  BWCSoundSampler.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BWCSoundSampler : NSObject <AVAudioRecorderDelegate>
{
     AVAudioRecorder *audioRecorder;
}

+(BWCSoundSampler*) sharedInstance;

@end
