//
//  CoreDataManager.m
//  Eisenhower
//
//  Created by Kavya on 23/12/15.
//  Copyright © 2015 Kavya. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager


#pragma Mark - shared instance

+ (instancetype)sharedManager {
    static CoreDataManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "vino93.CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Train" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"InbrixMobileApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            [managedObjectContext rollback];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //        abort();
            return NO;
        }
    }
    return YES;
}

#pragma mark - NearByLocation

- (BOOL)saveStations:(NSArray *)stations {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in stations) {
        NSString *stationId = [dic valueForKey:@"stationName"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationName == %@",stationId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Stations *stationList = [NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:moc];
            [stationList setStationId:[dic valueForKey:@"_id"]];
            [stationList setStationName:[dic valueForKey:@"stationName"]];
        }
    }
    return [self saveData];
}


- (NSArray *)fetchAllStations {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"stationName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

- (BOOL)saveDesignations:(NSArray *)designations {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Designation" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in designations) {
        NSString *stationId = [dic valueForKey:@"designation"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"designationName == %@",stationId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Designation *designationList = [NSEntityDescription insertNewObjectForEntityForName:@"Designation" inManagedObjectContext:moc];
            [designationList setDesignationId:[dic valueForKey:@"_id"]];
            [designationList setDesignationName:[dic valueForKey:@"designation"]];
        }
    }
    return [self saveData];
}


- (NSArray *)fetchAllDesignation {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Designation" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"designationName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

#pragma mark - Saving data

- (BOOL)saveData {
    return [self saveContext];
}

@end

