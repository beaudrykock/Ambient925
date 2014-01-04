//
//  BWCRealtimePlotViewController.h
//  Ambient925
//
//  Created by amit on 12/19/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface BWCRealtimePlotViewController : UIViewController <EZMicrophoneDelegate>
{

}

@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic, strong) IBOutlet UILabel* microphoneTextLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl* plotTypeSegment;
@property (nonatomic, strong) IBOutlet UISwitch* microphoneSwitch;

-(IBAction)changePlotType:(id)sender;
-(IBAction)toggleMicrophone:(id)sender;

@end
