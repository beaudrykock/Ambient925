//
//  BWCReachability.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCReachability.h"


@implementation BWCReachability

-(id) init
{
    self = [super init];
    if(self)
    {
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if (status == AFNetworkReachabilityStatusReachableViaWWAN)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kInternetReachableViaWWAN object:nil];
            }
            else if (status == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kInternetReachableViaWiFi object:nil];
            }
            else if (status == AFNetworkReachabilityStatusNotReachable ||
                     status == AFNetworkReachabilityStatusNotReachable)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kInternetNotReachable object:nil];
            }
        }];
    
    }
    return self;
}

@end
