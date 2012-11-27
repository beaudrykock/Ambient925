//
//  BWCCheckInManager.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//
//  Handles the posting of check-in data to all channels

#import "BWCCheckInManager.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"
#import "BWCSoundSampler.h"
#import "BWCSampleForUpload.h"

@implementation BWCCheckInManager

// Method called from check in view controller, with tags, comment and selection for a snapshot sound sample
// NOTE: view controller must supply the snapshot sample (see method in BWCSoundSampler)
-(void)checkInSample:(BWCSampleForUpload*)sample overChannels:(NSArray*)channels withTags:(NSMutableArray *)tags andComment:(NSString*)string
{
    // add tags
    sample.tags = [NSSet setWithArray:tags];
    
    // store the new sample as a BWCSoundSample
    [[BWCSoundSampler sharedInstance] storeUploadSample:sample];
    
    // upload to cloud, so tags and quotes are preserved in association with right sample
    [[BWCCloudGateway sharedInstance] uploadSample:sample withCompletion:nil andFailure:nil];
    
    // now, for each channel, make a post using the sample levels, associated tags/quotes, and any comment
    for (NSString* channel in channels)
    {
        if ([channel isEqualToString:kFacebookSharing])
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
            }
        }
        else if ([channel isEqualToString:kTwitterSharing])
        {
            
        }
        else if ([channel isEqualToString:kFourSquareSharing])
        {
            
        }
    }
}

@end
