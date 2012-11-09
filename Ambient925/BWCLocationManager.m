//
//  BWCLocationManager.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCLocationManager.h"

@implementation BWCLocationManager

+ (BWCLocationManager *)sharedInstance
{
    static BWCLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BWCLocationManager alloc] init];
        [sharedInstance startStandardUpdates];
        
    });
    return sharedInstance;
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not already have one.
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
    
        if (nil == self.locationManager)
        {
            CLLocationManager *cllm = [[CLLocationManager alloc] init];
            self.locationManager = cllm;
        }
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 500;
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        self.currentLocation = newLocation;
    }
}


@end
