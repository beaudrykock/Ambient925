//
//  BWCRealtimePlotViewController.m
//  Ambient925
//
//  Created by amit on 12/19/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCRealtimePlotViewController.h"
#import "BWCSoundSampler.h"

@interface BWCRealtimePlotViewController ()

@end

@implementation BWCRealtimePlotViewController

@synthesize plotStrip;
@synthesize plotLabel;

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
    // Do any additional setup after loading the view from its nib.
    
    // Configure the view
    UIImage *img = [UIImage imageNamed:@"background.png"];
    UIColor *clr = [[UIColor alloc] initWithPatternImage:img];
    [self.view setBackgroundColor:clr];
    
    plotStrip.lowerLimit = 0.0f;
    plotStrip.upperLimit = 200.0f;
    plotStrip.capacity = 60;
    plotStrip.baselineValue = 0.0f;
    plotStrip.lineColor = [UIColor greenColor];
    plotStrip.showDot = YES;
    plotStrip.labelFormat = @"Sound-driven: (%0.02f)";
    plotStrip.label = plotLabel;
    
    
    // Start the timer to provide data
    m_timer = [NSTimer scheduledTimerWithTimeInterval:kSamplingInterval
                                                target:self
                                              selector:@selector(didGetTimerEvent:)
                                              userInfo:nil
                                               repeats:YES];
}

- (void) didGetTimerEvent:(NSTimer *)a_timer
{
    // Add current slider value to plot strip
    float soundValue = (160-([[BWCSoundSampler sharedInstance] peakLevel]*-1));
    
    if(soundValue>130)
        plotStrip.lineColor = [UIColor redColor];
    else
        plotStrip.lineColor = [UIColor greenColor];
    
    plotStrip.value = soundValue;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    // Cancel the timer
    [m_timer invalidate];
    
    // Clean up
    [self setPlotStrip:nil];
}

@end
