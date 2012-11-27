//
//  BWCCloudGateway.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWCCloudManager.h"
#import "BWCParseManager.h"


@interface BWCCloudGateway : NSObject
{
    
}

@property (nonatomic, retain) BWCCloudManager *cloudManager;

+(BWCCloudGateway*) sharedInstance;

// PUBLIC METHODS
// accounts
-(void)newUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)loginAsAnonymousUserWithCompletion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)deleteLoggedInUserWithCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock;
-(void)logoutLoggedInUser;

// checkins
-(void)newCheckInWithTags:(NSArray*)tags andComment:(NSString*)comment;

// sampling
-(void)uploadSample:(BWCParseSample*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock;

@end
