//
//  BWCRealtimePlotViewController.h
//  Ambient925
//
//  Created by amit on 12/19/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@interface BWCRealtimePlotViewController : UIViewController<EZMicrophoneDelegate>
{

}

@property (strong, nonatomic) IBOutlet UILabel *plotLabel;
@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;

@end
