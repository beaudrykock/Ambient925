//
//  BWCDefines.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

// FOR REFERENCE
// Facebook test user -
// Username: yxatiol_martinazzison_1354102597@tfbnw.net
// Password: password

// DEBUGGING
#define TESTING 1
//#define TEST_SAMPLE_UPLOAD 1
//#define TEST_CHECKIN 1
#define TEST_SOUNDSAMPLING 1
//#define TEST_KVO 1

#define DEBUG_BWCPARSEMANAGER
#define DEBUG_BWCCLOUDGATEWAY

// UTILITIES
#define kGoogleAnalyticsTrackingID @"UA-35216488-2"
#define kParseApplicationID @"Ysfw1WQVYe3e4H3prCvAlIGaOFirtsEeT4DH7Yqn"
#define kParseClientKey @"0NvdG7jNXyMZemOPSJuW4qpwZG8rriQrlDr5WTXl"

// USER DEFAULTS
#define kUD_upgradeCheck @"upgradeCheck"

// SAMPLING
#ifdef TESTING
    #define kSamplingInterval 1.0 // time interval between sound samples
    #define kSampleUploadInterval 60.0
#else
    #define kSamplingInterval 60.0 // time interval between sound samples
    #define kSampleUploadInterval 900.0
#endif
#define kUP_lastSampleUploadDate @"lastSampleUploadDate"

// AFNetworking notifications
#define kInternetNotReachable @"internetNotReachable"
#define kInternetReachableViaWWAN @"internetReachableViaWWAN"
#define kInternetReachableViaWiFi @"internetReachableViaWiFi"

// SHARING
#define kFacebookSharing @"share_facebook"
#define kTwitterSharing @"share_twitter"
#define kFourSquareSharing @"share_foursquare"

// COREDATA
#define kDataModelName @"SampleDataModel"
