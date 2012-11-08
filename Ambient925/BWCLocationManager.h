//
//  BWCLocationManager.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BWCLocationManager : NSObject <CLLocationManagerDelegate>
{}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation* currentLocation;

+(BWCLocationManager*) sharedInstance;

@end
