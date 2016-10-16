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

#pragma mark - Save User

- (BOOL)saveLogedInUser:(NSDictionary *)logedInDict {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSString *email = [logedInDict valueForKey:@"email"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@",email];
    [request setPredicate:predicate];
    NSArray *array = [moc executeFetchRequest:request error:nil];
    if (array.count == 0) {
        User *userModel = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
        [userModel setEmail:[logedInDict valueForKey:@"email"]];
        [userModel setDesignation:[logedInDict valueForKey:@"designation"]];
        [userModel setStationName:[logedInDict valueForKey:@"stationName"]];
    }
    return [self saveData];
}

#pragma mark - Save Stations

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
            if ([dic valueForKey:@"statusColor"]) {
                [stationList setStatusColor:[[dic valueForKey:@"statusColor"] integerValue]];
            }
        }
    }
    return [self saveData];
}

#pragma mark - Save Designations

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


#pragma mark - Save Messages

- (BOOL)saveMessages:(NSArray *)messages {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in messages) {
        NSString *messageId = [dic valueForKey:@"messageId"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId == %@",messageId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Messages *messages = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:moc];
            [messages setMessage:[dic valueForKey:@"message"]];
            [messages setDesignation:[dic valueForKey:@"designation"]];
            [messages setCreateDate:[dic valueForKey:@"createDate"]];
            [messages setMessageId:[dic valueForKey:@"messageId"]];
            [messages setAddedDate:[NSDate date ]];
        }
    }
    return [self saveData];
}

#pragma mark - Save Home Images

- (BOOL)saveHomeImages:(NSArray *)images {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomeImages" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in images) {
        NSString *imagePath = [dic valueForKey:@"imageId"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %@",imagePath];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            HomeImages *images = [NSEntityDescription insertNewObjectForEntityForName:@"HomeImages" inManagedObjectContext:moc];
            [images setImagePath:[dic valueForKey:@"imagePath"]];
            [images setStationName:[dic valueForKey:@"stationName"]];
            [images setImageName:[dic valueForKey:@"imageTitle"]];
            [images setImageId:[dic valueForKey:@"imageId"]];
        }
    }
    return [self saveData];
}

#pragma mark - Save Home Images

- (BOOL)saveStationGalleryInfoImages:(NSArray *)images forKey:(NSString *)weekKey{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in images) {
        NSString *imagePath = [dic valueForKey:@"imageId"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %@",imagePath];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            StationGalleryInfo *images = [NSEntityDescription insertNewObjectForEntityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
            [images setImagePath:[dic valueForKey:@"imagePath"]];
            [images setStationName:[dic valueForKey:@"stationName"]];
            [images setImageName:[dic valueForKey:@"imageTitle"]];
            [images setImageId:[dic valueForKey:@"imageId"]];
            [images setGalleryWeek:weekKey];
        }
    }
    return [self saveData];
}

- (BOOL)saveWhatsNewMessages:(NSArray *)whatsNewMessages {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WhatsNewMessages" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in whatsNewMessages) {
        NSString *messageId = [dic valueForKey:@"createDate"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate == %@",messageId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            WhatsNewMessages *messages = [NSEntityDescription insertNewObjectForEntityForName:@"WhatsNewMessages" inManagedObjectContext:moc];
            [messages setMessage:[dic valueForKey:@"message"]];
            [messages setDesignation:[dic valueForKey:@"designation"]];
            [messages setCreateDate:[dic valueForKey:@"createDate"]];
            [messages setStationName:[dic valueForKey:@"stationName"]];
            [messages setMessageId:[dic valueForKey:@"messageId"]];
            [messages setAddedDate:[NSDate date ]];
        }
    }
    return [self saveData];
}

#pragma mark - Save Station Tasks

- (BOOL)saveStationTasks:(NSArray *)stationTasks forStationId:(NSString *)stationId {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in stationTasks) {
        NSString *refId = [dic valueForKey:@"refId"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"refId == %@",refId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Tasks *tasks = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:moc];
            [tasks setDomain:[dic valueForKey:@"domain"]];
            [tasks setEventName:[dic valueForKey:@"eventName"]];
            [tasks setRefId:[dic valueForKey:@"refId"]];
            [tasks setStatus:[[dic valueForKey:@"status"] integerValue]];
            [tasks setStationId:stationId];
        }
    }
    return [self saveData];
}

#pragma mark - Save Station sub tasks

- (BOOL)saveSubTasks:(NSArray *)subTasks forTaskId:(NSString *)taskId{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubTasks" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in subTasks) {
        NSString *stationSubActivityId = [NSString stringWithFormat:@"%ld",[[dic valueForKey:@"stationSubActivityId"] integerValue]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationSubActivityId == %@",stationSubActivityId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            SubTasks *subTasks = [NSEntityDescription insertNewObjectForEntityForName:@"SubTasks" inManagedObjectContext:moc];
            [subTasks setName:[dic valueForKey:@"name"]];
            NSString *stationSubActivityId = [NSString stringWithFormat:@"%ld",[[dic valueForKey:@"stationSubActivityId"] integerValue]];
            [subTasks setStationSubActivityId:stationSubActivityId];
            [subTasks setExecuteAgency:[dic valueForKey:@"executeAgency"]];
            [subTasks setDeadline:[dic valueForKey:@"deadline"]];
            [subTasks setTaskId:taskId];
            [subTasks setStatus:[[dic valueForKey:@"status"] integerValue]];
        }
    }
    return [self saveData];
}

#pragma mark - Save Station sub tasks

- (BOOL)saveRemarks:(NSArray *)remarks forTaskId:(NSString *)taskId{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Remarks" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in remarks) {
        NSString *remarksId = [dic valueForKey:@"remarksId"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remarksId == %@",remarksId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Remarks *remarks = [NSEntityDescription insertNewObjectForEntityForName:@"Remarks" inManagedObjectContext:moc];
            [remarks setInsertDate:[dic valueForKey:@"insertDate"]];
            [remarks setRemarksId:[dic valueForKey:@"remarksId"]];
            [remarks setMessage:[dic valueForKey:@"message"]];
            [remarks setStatus:[[dic valueForKey:@"status"] integerValue]];
            [remarks setTaskId:taskId];
        }
    }
    return [self saveData];
}


#pragma mark - User Object

- (User *)fetchLogedInUser {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  (User *)[result firstObject];
}

#pragma mark - Fetch Stations

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

#pragma mark - fetch All Destinations

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

#pragma mark - fetch Home Messages

- (NSArray *)fetchHomeMessages {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"addedDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

#pragma mark - fetch Home Images

- (NSArray *)fetchHomeImages {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomeImages" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}
#pragma mark - fetch station Gallery Images

- (NSArray *)fetchStationGalleryImagesForKey:(NSString*)weekKey {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"galleryWeek == %@",weekKey];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

#pragma mark - fetch What's new messages based on station name
- (NSArray *)fetchWhatsNewMessages {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WhatsNewMessages" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

#pragma mark - Saving data

- (BOOL)saveData {
    return [self saveContext];
}

@end

