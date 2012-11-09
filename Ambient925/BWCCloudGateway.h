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
@property (nonatomic) NSTimeInterval sampleUploadInterval;
@property (nonatomic, retain) NSMutableArray *sampleUploadQueue;
@property (nonatomic, retain) NSTimer *sampleUploadTimer;
@property (nonatomic) BOOL uploading;
@property (nonatomic) BOOL uploadingPaused;

+(BWCCloudGateway*) sharedInstance;

// accounts
-(void)newUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)loginAsAnonymousUserWithCompletion:(void (^)(void))completionBlock failure:(void (^)(void))failureBlock;
-(void)deleteLoggedInUserWithCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock;
-(void)logoutLoggedInUser;

// checkins
-(void)newCheckInWithLocation:(CLLocation*)loc andTags:(NSArray*)tags andComment:(NSString*)comment toSocialChannels:(NSArray*)channels;

// samples
-(void)uploadSample:(BWCSoundSample*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock;

// Methods unique to BWCCloudGateway
-(void)queueSampleForUpload:(BWCSoundSample*)sample;
-(void)pauseUploads;
-(void)resumeUploads;

@end
