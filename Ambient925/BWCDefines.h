//
//  BWCDefines.h
//  Ambient925
//
//  Created by Beaudry Kock on 11/8/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

// UTILITIES
#define kGoogleAnalyticsTrackingID @"UA-35216488-2"
#define kTestFlightID @"6410a6f8585edb65208670f4da2dfba3_NDM3MzMyMDExLTExLTI4IDA0OjU3OjI0LjQ5NTU5Nw"
#define kParseApplicationID @"Ysfw1WQVYe3e4H3prCvAlIGaOFirtsEeT4DH7Yqn"
#define kParseClientKey @"0NvdG7jNXyMZemOPSJuW4qpwZG8rriQrlDr5WTXl"

#define TESTING 1

// USER DEFAULTS
#define kUD_upgradeCheck @"upgradeCheck"

// SAMPLING
#ifdef TESTING
    #define kSamplingInterval 1.0 // time interval between sound samples
#else
    #define kSamplingInterval 60.0 // time interval between sound samples
#endif

// AFNetworking notifications
#define kInternetNotReachable @"internetNotReachable"
#define kInternetReachableViaWWAN @"internetReachableViaWWAN"
#define kInternetReachableViaWiFi @"internetReachableViaWiFi"

// DEBUGGING

#define DEBUG_BWCPARSEMANAGER
#define DEBUG_BWCCLOUDGATEWAY