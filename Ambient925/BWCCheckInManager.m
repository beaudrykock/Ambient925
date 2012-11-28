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

+ (BWCCheckInManager *)sharedInstance
{
    static BWCCheckInManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BWCCheckInManager alloc] init];
    });
    return sharedInstance;
}


// Method called from check in view controller, with tags, comment and selection for a snapshot sound sample
// NOTE: view controller must supply the snapshot sample (see method in BWCSoundSampler)
-(void)checkInSample:(BWCSampleForUpload*)sample overChannels:(NSArray*)channels withTags:(NSMutableArray *)tags andComment:(NSString*)string
{
    // add tags
    sample.tags = [NSSet setWithArray:tags];
    
    // store the new sample as a BWCSoundSample
    //[[BWCSoundSampler sharedInstance] storeUploadSample:sample];
        
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
            if ([TWTweetComposeViewController canSendTweet])
            {
                // Create account store, followed by a twitter account identifier
                // At this point, twitter is the only account type available
                ACAccountStore *account = [[ACAccountStore alloc] init];
                ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                
                // Request access from the user to access their Twitter account
                [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
                 {
                     // Did user allow us access?
                     if (granted == YES)
                     {
                         // Populate array with all available Twitter accounts
                         NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                         
                         // Sanity check
                         if ([arrayOfAccounts count] > 0)
                         {
                             // Keep it simple, use the first account available
                             ACAccount *acct = [arrayOfAccounts objectAtIndex:1];
                             if ([acct.username isEqualToString:@"BWC_test"])
                             {
                                 // Build a twitter request
                                 //NSLog(@"status text = %@", text);
                                 //NSLog(@"reply id = %@", replyID);
                                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:
                                                           [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                                                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                          @"Just posted a sound sample", @"status", nil] requestMethod:TWRequestMethodPOST];
                                 // [NSDictionary dictionaryWithObject:@"Test test"                 forKey:@"status"]
                                 
                                 // Post the request
                                 [postRequest setAccount:acct];
                                 
                                 // Block handler to manage the response
                                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                                  {
                                      //NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                                      //NSLog(@"Error = %@", [NSHTTPURLResponse localizedStringForStatusCode: [urlResponse statusCode]]);
                                      
                                      if ([urlResponse statusCode]==200)
                                      {
                                          dispatch_sync(dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView *tweetFailed = [[UIAlertView alloc] initWithTitle:@"Tweet success" message:@"Woot woot" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                              [tweetFailed show];
                                              
                                          });//end block
                                      }
                                      else
                                      {
                                          UIAlertView *tweetFailed = [[UIAlertView alloc] initWithTitle:@"Tweet failed" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                          [tweetFailed show];
                                      }
                                  }];
                             }
                         }
                     }
                 }];
                
            }
        }
        else if ([channel isEqualToString:kFourSquareSharing])
        {
            
        }
    }
}

@end
