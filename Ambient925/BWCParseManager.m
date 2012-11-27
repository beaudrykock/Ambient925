//
//  BWCParseManager.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCParseManager.h"

@implementation BWCParseManager

#pragma mark - User account management
-(void)newUserWithUsername:(NSString*)username
                  password:(NSString*)password
                  completion:(void (^)(void))completionBlock
                  failure:(void (^)(void))failureBlock
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
#ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Success in signing up user");
#endif
            if (completionBlock != nil) completionBlock();
            
        } else {
#ifdef DEBUG_BWCPARSEMANAGER
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Sign in error %@", errorString);
#endif
            if (failureBlock != nil) failureBlock();
        }
    }];
    
    // also store in the keychain
    PDKeychainBindings *keyChain =[PDKeychainBindings sharedKeychainBindings];
    if (![[keyChain objectForKey:@"Parse Username"] isEqualToString:username] && ![[keyChain objectForKey:@"Parse Password"] isEqualToString:password])
    {
        [keyChain setObject:username forKey:@"Parse Username"];
        [keyChain setObject:password forKey:@"Parse Password"];
    }
}

-(void)loginAsAnonymousUserWithCompletion:(void (^)(void))completionBlock
                                  failure:(void (^)(void))failureBlock
{
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            if (failureBlock != nil) failureBlock();
            #ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Anonymous login failed.");
#endif
        }
        else {
            if (completionBlock != nil) completionBlock();
            #ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Anonymous user logged in.");
#endif
        }
    }];
}

-(void)loginUserWithUsername:(NSString*)username
                    password:(NSString*)password
                    completion:(void (^)(void))completionBlock
                    failure:(void (^)(void))failureBlock
{
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user)
                                        {
#ifdef DEBUG_BWCPARSEMANAGER
                                            NSLog(@"Successfully logged in user");
#endif
                                            if (completionBlock != nil) completionBlock();
                                        }
                                        else {
#ifdef DEBUG_BWCPARSEMANAGER
                                            NSLog(@"Failed to login user");
#endif
                                            if (failureBlock != nil) failureBlock();
                                        }
                                    }];

}

-(void)deleteLoggedInUserWithCompletion:(void (^)(void))completionBlock
                             andFailure:(void (^)(void))failureBlock
{
    PFUser *user = [PFUser user];
    [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
#ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Successfully deleted user");
#endif
            if (completionBlock != nil) completionBlock();
        }
        else
        {
#ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Failed to delete user");
#endif
            if (failureBlock != nil) failureBlock();
        }
        
    }];
}

-(void)logoutLoggedInUser
{
    [PFUser logOut];
}

#pragma mark - Sound samples
-(void)uploadSample:(BWCSoundSample*)sample withCompletion:(void (^)(void))completionBlock andFailure:(void (^)(void))failureBlock
{

    PFGeoPoint *location = [PFGeoPoint geoPointWithLatitude:[sample.latitude floatValue] longitude:[sample.longitude floatValue]];
    
    PFObject *soundSample = [PFObject objectWithClassName:@"BWCSoundSample"];
    [soundSample setObject: sample.averageSoundLevel forKey:@"averageSoundLevel"];
    [soundSample setObject: sample.peakSoundLevel forKey:@"peakSoundLevel"];
    [soundSample setObject: sample.interval forKey:@"interval"];
    [soundSample setObject: location forKey:@"location"];
    [soundSample setObject: sample.date forKey:@"date"];
    [soundSample setObject: [sample tags] forKey:@"tags"];
    [soundSample setObject: [sample quotes] forKey:@"quotes"];
    [soundSample saveEventually:^(BOOL succeeded, NSError *error)
                                            {
                                                if (succeeded)
                                                {
#ifdef DEBUG_BWCPARSEMANAGER
                                                    NSLog(@"Sample upload succeeded");
#endif
                                                    if (completionBlock != nil) completionBlock();
                                                }
                                                else
                                                {
#ifdef DEBUG_BWCPARSEMANAGER
                                                    NSLog(@"Sample upload failed");
#endif
                                                    if (failureBlock != nil) failureBlock();
                                                }
                                            }];
}

#pragma mark - Checkins
/*
 * Updates the most recent sound sample with the tags and comment
 */
-(void)newCheckInWithTags:(NSArray*)tags andComment:(NSString*)comment
{
    // 1. retrieve most recent object
    PFQuery *query = [PFQuery queryWithClassName:@"BWCSoundSample"];
    [query orderByAscending:@"sampleDate"];
    
    NSArray *objects = [query findObjects];
    
    PFObject *obj = [objects objectAtIndex:0];
    
    NSDate *date = (NSDate*)[obj objectForKey:@"sampleDate"];
    NSLog(@"obj date created = %@", [date description]);
    
    // 2. add tag objects with SoundSample as parent
    for (NSString *tag in tags)
    {
        PFObject *tagObj = [PFObject objectWithClassName:@"soundSampleTag"];
        [tagObj setObject:tag forKey:@"tag"];
        [tagObj setObject:obj forKey:@"parent"];
        [tagObj saveInBackground];
    }
    
    // 3. add comment object with SoundSample as parent
    PFObject *commentObj = [PFObject objectWithClassName:@"soundSampleComment"];
    [commentObj setObject:comment forKey:@"comment"];
    [commentObj setObject:obj forKey:@"parent"];
    [commentObj saveInBackground];
}

@end
