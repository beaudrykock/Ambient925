//
//  BWCSoundSampler.m
//  Ambient925
//
//  Created by Beaudry Kock on 11/27/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCSoundSampler.h"

@implementation BWCSoundSampler

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (BWCSoundSampler *)sharedInstance
{
    static BWCSoundSampler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BWCSoundSampler alloc] init];
        
        //NSLog(@"%@", [sharedInstance managedObjectModel]);
        // code adapted from:
        // http://mobileorchard.com/tutorial-detecting-when-a-user-blows-into-the-mic/
        
        NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
        
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                  nil];
        
        NSError *error;
        
        sharedInstance.sampler = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        
        if (sharedInstance.sampler) {
            [sharedInstance.sampler prepareToRecord];
            sharedInstance.sampler.meteringEnabled = YES;
            [sharedInstance.sampler record];
            [sharedInstance setSamplingTimer];
            
        } else
            NSLog(@"%@",[error localizedDescription]);
    });
    return sharedInstance;
}

-(void)setSamplingTimer
{
    self.sampleTimer = [NSTimer scheduledTimerWithTimeInterval: kSamplingInterval target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

/*
 * 1. Gets the current average and peak from the AVAudioRecorder
 * 2. Grabs any sound quotes for the average sound level
 * 3. Creates and parameterizes a BWCSoundSample object and adds to CoreData database
 * 4. If we're ready for a Parse upload, calls that upload with the BWCSoundSample object
 */
- (void)levelTimerCallback:(NSTimer *)timer {
	[self.sampler updateMeters];
    
    float average = [self.sampler averagePowerForChannel:0];
    float peak = [self.sampler peakPowerForChannel:0];
    
    //float average_linear = pow(10., 0.05 * average);
    //float peak_linear = pow(10., 0.05 * peak);;
	//NSLog(@"Average input (db): %f Peak input (db): %f", average, peak);
    
    // TODO: create and store these values in CoreData
    NSManagedObjectContext *context = [self managedObjectContext];
    
    BWCSoundSample *sample = [NSEntityDescription insertNewObjectForEntityForName:@"BWCSoundSample" inManagedObjectContext:context];
    
    sample.averageSoundLevel = [NSNumber numberWithFloat:(160-(average*-1))];
    sample.peakSoundLevel = [NSNumber numberWithFloat:(160-(peak*-1))];
    sample.interval = [NSNumber numberWithLongLong:timer.timeInterval];
    sample.date = [NSDate date];
    sample.longitude = [NSNumber numberWithFloat:[[BWCLocationManager sharedInstance] currentLocation].coordinate.longitude];
    sample.latitude = [NSNumber numberWithFloat:[[BWCLocationManager sharedInstance] currentLocation].coordinate.latitude];
    
    NSMutableArray *quotes = [self getQuotesForAverageLevel:average];
    for (NSString *quoteText in quotes)
    {
        BWCSoundQuote *quote = [NSEntityDescription insertNewObjectForEntityForName:@"BWCSoundQuote" inManagedObjectContext:context];
        quote.contents = quoteText;
        [sample addQuotesObject:quote];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save with error = %@", [error description]);
    }
    
    //[self printSoundSamples];
    
    if ([BWCUtilities sampleUploadIntervalExceeded])
    {
        NSLog(@"Uploading to Parse");
        [self uploadAverageFromPreviousInterval];
        [BWCUtilities sampleUploaded];
    }
}

- (BWCSampleForUpload*)snapshot
{
    float average = [self.sampler averagePowerForChannel:0];
    float peak = [self.sampler peakPowerForChannel:0];
    
    BWCSampleForUpload* sample = [[BWCSampleForUpload alloc] init];
    
    sample.averageSoundLevel = [NSNumber numberWithFloat:average];
    sample.peakSoundLevel = [NSNumber numberWithFloat:peak];
    sample.date = [NSDate date];
    sample.interval = [NSNumber numberWithFloat:kSamplingInterval];
    sample.longitude = [NSNumber numberWithFloat:[[BWCLocationManager sharedInstance] currentLocation].coordinate.longitude];
    sample.latitude = [NSNumber numberWithFloat:[[BWCLocationManager sharedInstance] currentLocation].coordinate.latitude];
    sample.quotes = [NSSet setWithArray:[self getQuotesForAverageLevel:average]];
    return sample;
}

//
// Method for converting a BWCSampleForUpload into a BWCSoundSample and storing in the Core Data model
// e.g. when BWCCheckInManager needs to store a snapshot it took for a check in
//
//
-(void)storeUploadSample:(BWCSampleForUpload*)sample
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    BWCSoundSample *soundSample = [NSEntityDescription insertNewObjectForEntityForName:@"BWCSoundSample" inManagedObjectContext:context];
    
    soundSample.averageSoundLevel = sample.averageSoundLevel;
    soundSample.peakSoundLevel = sample.peakSoundLevel;
    soundSample.interval = sample.interval;
    soundSample.date = sample.date;
    soundSample.longitude = sample.longitude;
    soundSample.latitude = sample.latitude;
    soundSample.quotes = sample.quotes;
    soundSample.tags = sample.tags;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save with error = %@", [error description]);
    }
}

/*
 * 1. Queries all BWCSoundSample objects added in the last X seconds (depending on the kSampleUploadInterval)
 * 2. Calculates average sound level and peak sound level for all those samples
 * 3. Creates a BWCParseSample object with the averaged values, latest location and passes to CloudManager class for upload to Parse
 */
-(void)uploadAverageFromPreviousInterval
{
    // get all samples from within last interval
    NSDate * currentLessInterval = [[NSDate date] dateByAddingTimeInterval:-1*kSampleUploadInterval];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"BWCSoundSample" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date > %@", currentLessInterval];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    BWCSampleForUpload *aggregateSample = [[BWCSampleForUpload alloc] init];
    
    float averageLevel;
    
    aggregateSample.peakSoundLevel = [NSNumber numberWithFloat:0.0];
    
    if ([fetchedObjects count]==0)
    {
        aggregateSample.averageSoundLevel = [NSNumber numberWithFloat:0.0];
        aggregateSample.longitude = [NSNumber numberWithFloat:0.0];
        aggregateSample.latitude = [NSNumber numberWithFloat:0.0];
    }
    else
    {
        NSLog(@"Calculating average for %i samples", [fetchedObjects count]);
        for (BWCSoundSample *sample in fetchedObjects)
        {
            averageLevel += sample.averageSoundLevel.floatValue;
            if (aggregateSample.peakSoundLevel.floatValue < sample.peakSoundLevel.floatValue)
                aggregateSample.peakSoundLevel = sample.peakSoundLevel;
        }
        
        aggregateSample.averageSoundLevel = [NSNumber numberWithFloat:(averageLevel / ([fetchedObjects count]*1.0))];
        
        BWCSoundSample *mostRecentSample = [fetchedObjects objectAtIndex:0];
        
        aggregateSample.latitude = mostRecentSample.latitude;
        aggregateSample.longitude = mostRecentSample.longitude;
    }
    
    aggregateSample.date = [NSDate date];
    aggregateSample.interval = [NSNumber numberWithFloat:kSamplingInterval];
    
    [[BWCCloudGateway sharedInstance] uploadSample:aggregateSample withCompletion:nil andFailure:nil];
}

-(NSMutableArray*)getQuotesForAverageLevel:(float)level
{
    // TODO: complete
    return [NSMutableArray arrayWithObjects:@"Monastery", @"Sound Studio", nil];
}

#pragma mark - Core Data queries
-(void)printSoundSamples
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"BWCSoundSample" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    for (BWCSoundSample *sample in fetchedObjects)
    {
        NSLog(@"Sound sample: average size - %f, date %@", sample.averageSoundLevel.floatValue, sample.date.description);
    }
}

#pragma mark - Core Data stack
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDataModelName withExtension:@"momd"];
    //NSLog(@"modelURL %@", [modelURL description]);
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDataModelName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
