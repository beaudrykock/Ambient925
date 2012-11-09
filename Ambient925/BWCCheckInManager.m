//
//  BWCCheckInManager.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCCheckInManager.h"
#import "Social/Social.h"
#import "Accounts/Accounts.h"

@implementation BWCCheckInManager


-(void)checkInWithChannels:(NSArray*)channels
{
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
