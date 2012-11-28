//
//  BWCSoundBoxViewController.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/9/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCSoundBoxViewController.h"

@interface BWCSoundBoxViewController ()

@end

@implementation BWCSoundBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
#ifdef TESTING   
    
#ifdef TEST_SAMPLE_UPLOAD
    [NSTimer scheduledTimerWithTimeInterval:kSamplingInterval target:self selector:@selector(testSampling) userInfo:nil repeats:YES];
#endif
    
#ifdef TEST_CHECKIN
    [self testCheckIn];
#endif
    
#ifdef TEST_SOUNDSAMPLING
    [self testSoundSampling];
#endif

#ifdef TEST_KVO
    [self testSoundLevelKVO];
#endif
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"%@ value changed to %@", keyPath, [change objectForKey:NSKeyValueChangeNewKey]);
}


#pragma mark - TEST METHODS
// creates and queues a sample
-(void)testSampling
{
    // DEPRECATED
}

-(void)testCheckIn
{
    // TODO: implement
}

-(void)testSoundLevelKVO
{
    [[BWCSoundSampler sharedInstance] addObserver:self forKeyPath:@"averageLevel" options:NSKeyValueObservingOptionNew context:NULL];
    [[BWCSoundSampler sharedInstance] addObserver:self forKeyPath:@"peakLevel" options:NSKeyValueObservingOptionNew context:NULL];
}


-(void)testSoundSampling
{
    [BWCSoundSampler sharedInstance];
}

-(IBAction)testFacebook
{
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"logged in");
    } else {
        BWCAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate openSession];
    }
}

- (IBAction)testPostFacebook
{
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self testPublish];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self testPublish];
    }
    
    
}

-(void)testPublish
{
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"https://developers.facebook.com/ios", @"link",
     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
     @"Facebook SDK for iOS", @"name",
     @"Build great social apps and get more installs.", @"caption",
     @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
     nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d, description = %@",
                          error.domain, error.code, error.description];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

-(IBAction)testTwitterPost
{
    BWCSampleForUpload *sample = [[BWCSoundSampler sharedInstance] snapshot];
    [[BWCCheckInManager sharedInstance] checkInSample:sample overChannels:[NSArray arrayWithObject:kTwitterSharing] withTags:[NSArray arrayWithObject:@"testTag"] andComment:@"testComment"];
}



@end
