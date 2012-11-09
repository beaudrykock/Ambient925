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
#define kSamplingInterval 60.0 // time interval between sound samples
#define kDefaultUploadInterval 600.0 // default time interval for uploads
#define kWWANUploadInterval 600.0 // time interval between uploads, for WWAN
#define kWiFiUploadInterval 300.0 // time interval between uploads, for WiFi


// AFNetworking notifications
#define kInternetNotReachable @"internetNotReachable"
#define kInternetReachableViaWWAN @"internetReachableViaWWAN"
#define kInternetReachableViaWiFi @"internetReachableViaWiFi"