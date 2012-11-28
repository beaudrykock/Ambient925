//
//  BWCCloudGateway.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//
/*
 * TO USE
 *
 * 1. Get a shared instance, e.g. BWCCloudGateway *bcg = [BWCCloudGateway sharedInstance];
 * 2. FOR SAMPLING UPLOADS: [bcg uploadSample...];
 * 3. FOR USER ACCOUNT MANAGEMENT: refer to range of user account management methods
 *
 */

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

#pragma mark - Sampling methods (PUBLIC)
-(void)uploadSample:(BWCSampleForUpload*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock
{
    [self.cloudManager uploadSample:sample withCompletion:completionBlock andFailure:failureBlock];
}

#pragma mark - Facade methods for BWCCloudManager
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

@end
