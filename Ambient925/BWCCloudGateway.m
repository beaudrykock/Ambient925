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
        NSMutableArray *queue = [[NSMutableArray alloc] init];
        sharedInstance.sampleUploadQueue = queue;
        sharedInstance.sampleUploadInterval = kDefaultUploadInterval;
        [sharedInstance updateSampleFrequency];
        [sharedInstance subscribeToReachability];
    });
    return sharedInstance;
}

#pragma mark - Sampling methods (PUBLIC)
-(void)queueSampleForUpload:(BWCSoundSample*)sample
{
    [self.sampleUploadQueue addObject:sample];
}

-(void)resumeUploads
{
    self.uploadingPaused = NO;
    [self updateSampleFrequency];
}

-(void)pauseUploads
{
    if (self.sampleUploadTimer != nil)
    {
        self.uploadingPaused = YES;
        [self.sampleUploadTimer invalidate];
        self.sampleUploadTimer = nil;
    }
}

#pragma mark - Sampling methods (PRIVATE)
-(void)subscribeToReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustSamplingRate:) name:kInternetReachableViaWWAN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustSamplingRate:) name:kInternetReachableViaWiFi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustSamplingRate:) name:kInternetNotReachable object:nil];
}

-(void)adjustSamplingRate:(NSNotification*)notification
{
    if (!self.uploadingPaused)
    {
        if ([notification.name isEqualToString:kInternetNotReachable])
        {
            [self.sampleUploadTimer invalidate];
            self.sampleUploadTimer = nil;
        }
        else if ([notification.name isEqualToString:kInternetReachableViaWiFi])
        {
            if (self.sampleUploadInterval != kWiFiUploadInterval)
            {
                self.sampleUploadInterval = kWiFiUploadInterval;
                [self updateSampleFrequency];
            }
        }
        else if ([notification.name isEqualToString:kInternetReachableViaWWAN])
        {
            if (self.sampleUploadInterval != kWWANUploadInterval)
            {
                self.sampleUploadInterval = kWWANUploadInterval;
                [self updateSampleFrequency];
            }
        }

    }
}

-(void)uploadSamples
{
    if (!self.uploading)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            
            for (BWCSoundSample *sample in self.sampleUploadQueue)
            {
                [self uploadSample:sample withCompletion:nil andFailure:nil];
            }
        });
    }
}

// launches updating timer, based on current sampleUploadInterval
-(void)updateSampleFrequency
{
    if (self.sampleUploadTimer != nil)
    {
        [self.sampleUploadTimer invalidate];
        self.sampleUploadTimer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.sampleUploadInterval target:self selector:@selector(uploadSamples) userInfo:nil repeats:YES];;
    self.sampleUploadTimer = timer;
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

// checkins
-(void)newCheckInWithLocation:(CLLocation*)loc andTags:(NSArray*)tags andComment:(NSString*)comment toSocialChannels:(NSArray*)channels
{
    [self.cloudManager newCheckInWithLocation:loc andTags:tags andComment:comment toSocialChannels:channels];
}

// samples
-(void)uploadSample:(BWCSoundSample*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock
{
    [self.cloudManager uploadSample:sample withCompletion:completionBlock andFailure:failureBlock];
 
    // sample must be removed from the queue, in case a new upload thread is spawned
    // and samples could be duplicated
    if ([self.sampleUploadQueue containsObject:sample])
        [self.sampleUploadQueue removeObject:sample];
}


@end
