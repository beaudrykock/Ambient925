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
            completionBlock();
            
        } else {
#ifdef DEBUG_BWCPARSEMANAGER
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Sign in error %@", errorString);
#endif
            failureBlock();
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
            failureBlock();
            #ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Anonymous login failed.");
#endif
        }
        else {
            completionBlock();
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
                                            completionBlock();
                                        }
                                        else {
#ifdef DEBUG_BWCPARSEMANAGER
                                            NSLog(@"Failed to login user");
#endif
                                            failureBlock();
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
            completionBlock();
        }
        else
        {
#ifdef DEBUG_BWCPARSEMANAGER
            NSLog(@"Failed to delete user");
#endif
            failureBlock();
        }
        
    }];
}

-(void)logoutLoggedInUser
{
    [PFUser logOut];
}

#pragma mark - Checkins
-(void)newCheckinWithLocation:(CLLocation*)loc andTags:(NSArray*)tags
{
    
}

@end
