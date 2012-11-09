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
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TEST METHODS
// creates and queues a sample
-(void)testSampling
{
    NSLog(@"Creating and queueing a new sample");
    BWCSoundSample *newSample = [[BWCSoundSample alloc] init];
    [newSample setSampleDate:[NSDate date]];
    [newSample setSoundLevel:arc4random_uniform(10)*1.0];
    [newSample setSampleLocation:[[BWCLocationManager sharedInstance] currentLocation]];
    [newSample setSoundQuote:@"Monastery"];
    [newSample setTags:[NSArray arrayWithObjects:@"1", @"2", nil]];
    [[BWCCloudGateway sharedInstance] uploadSample:newSample withCompletion:nil andFailure:nil];
    
}

-(void)testCheckIn
{
    [[BWCCloudGateway sharedInstance] newCheckInWithTags:[NSArray arrayWithObjects:@"home", nil] andComment:@"Loud!"];
}

@end
