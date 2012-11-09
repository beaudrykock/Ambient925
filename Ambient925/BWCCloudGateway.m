//
//  BWCCloudGateway.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCCloudGateway.h"

@implementation BWCCloudGateway

+ (BWCCloudGateway *)sharedInstance
{
    static BWCCloudGateway *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BWCCloudGateway alloc] init];
        
        // change this line if a different cloud storage solution is used
        BWCCloudManager *bcm = [[BWCParseManager alloc] init];
        sharedInstance.cloudManager = bcm;
    });
    return sharedInstance;
}

// accounts
-(void)newUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock
{
    [self.cloudManager newUserWithUsername:username password:password completion:completionBlock failure:failureBlock];
}

-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock
{
    [self.cloudManager loginUserWithUsername:username password:password completion:completionBlock failure:failureBlock];
}

-(void)loginAsAnonymousUserWithCompletion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock
{
    [self.cloudManager loginAsAnonymousUserWithCompletion:completionBlock failure:failureBlock];
}

-(void)deleteLoggedInUserWithCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock
{
    [self.cloudManager deleteLoggedInUserWithCompletion:completionBlock andFailure:failureBlock];
}

-(void)logoutLoggedInUser
{
    [self.cloudManager logoutLoggedInUser];
}

// checkins
-(void)newCheckInWithLocation:(CLLocation*)loc andTags:(NSArray*)tags andComment:(NSString*)comment toSocialChannels:(NSArray*)channels
{
    [self.cloudManager newCheckInWithLocation:loc andTags:tags andComment:comment toSocialChannels:channels];
}

// samples
-(void)uploadSample:(BWCSoundSample*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock
{
    [self.cloudManager uploadSample:sample withCompletion:completionBlock andFailure:failureBlock];
}


@end
