//
//  BWCRealtimePlotViewController.h
//  Ambient925
//
//  Created by amit on 12/19/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F3PlotStrip.h"

@interface BWCRealtimePlotViewController : UIViewController
{
@private
    NSTimer     *m_timer;       // Timer for updating values
}

@property (strong, nonatomic) IBOutlet F3PlotStrip *plotStrip;
@property (strong, nonatomic) IBOutlet UILabel *plotLabel;

@end
