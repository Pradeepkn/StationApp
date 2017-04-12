//
//  CoreDataManager.m
//  Eisenhower
//
//  Created by Kavya on 23/12/15.
//  Copyright © 2015 Kavya. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"

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
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
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
    User *userModel;
    if (array.count == 0) {
        userModel = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
    }else {
        userModel = (User *)[array firstObject];
    }
    [userModel setEmail:[logedInDict valueForKey:@"email"]];
    [userModel setDesignation:[logedInDict valueForKey:@"designation"]];
    [userModel setStationName:[logedInDict valueForKey:@"stationName"]];
    return [self saveData];
}

#pragma mark - Save Stations

- (BOOL)saveStations:(NSArray *)stations  forPhase:(NSInteger)phaseNumber {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in stations) {
        id stationReferenceId = [dic valueForKey:@"_id"];
        NSString *stationId = [NSString stringWithFormat:@"%@",stationReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationId == %@ && phaseNumber == %ld",stationId, phaseNumber];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Stations *stationList = [NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:moc];
            [stationList setStationId:stationId];
            [stationList setStationName:[dic valueForKey:@"stationName"]];
            [stationList setStationCode:[dic valueForKey:@"stationCode"]];
            [stationList setPhaseNumber:phaseNumber];
            if ([dic valueForKey:@"statusColor"]) {
                [stationList setStatusColor:[[dic valueForKey:@"statusColor"] integerValue]];
            }
        }
    }
    return [self saveData];
}

#pragma mark - Save Designations

- (BOOL)saveDesignations:(NSArray *)designations forPhase:(NSInteger)phaseNumber {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Designation" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in designations) {
        id designationReferenceId = [dic valueForKey:@"_id"];
        NSString *designationId = [NSString stringWithFormat:@"%@",designationReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"designationId == %@ && phaseNumber == %ld",designationId, phaseNumber];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Designation *designationList = [NSEntityDescription insertNewObjectForEntityForName:@"Designation" inManagedObjectContext:moc];
            [designationList setDesignationId:designationId];
            [designationList setDesignationName:[dic valueForKey:@"designation"]];
            [designationList setPhaseNumber:phaseNumber];
        }
    }
    return [self saveData];
}


#pragma mark - Save Messages

- (BOOL)saveMessages:(NSArray *)messages forPhase:(NSInteger)phaseNumber {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in messages) {
        id messageReferenceId = [dic valueForKey:@"messageId"];
        NSString *messageId = [NSString stringWithFormat:@"%@",messageReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId == %@",messageId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            Messages *messages = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:moc];
            [messages setMessage:[dic valueForKey:@"message"]];
            [messages setDesignation:[dic valueForKey:@"designation"]];
            [messages setCreateDate:[AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"createDate"]]];
            [messages setDeleteMessage:[[dic valueForKey:@"deleteMessage"] boolValue]];
            [messages setMessageId:messageId];
            [messages setUsername:[dic valueForKey:@"username"]];
            [messages setPhaseNumber:phaseNumber];
        }
    }
    return [self saveData];
}

#pragma mark - Save Home Images

- (BOOL)saveHomeImages:(NSArray *)images forPhase:(NSInteger)phaseNumber {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomeImages" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in images) {
        id imageReferenceId = [dic valueForKey:@"imageId"];
        NSString *imageId = [NSString stringWithFormat:@"%@",imageReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %@",imageId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            HomeImages *images = [NSEntityDescription insertNewObjectForEntityForName:@"HomeImages" inManagedObjectContext:moc];
            [images setInsertDate:[AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"insertDate"]]];
            [images setImagePath:[dic valueForKey:@"imagePath"]];
            [images setStationName:[dic valueForKey:@"stationName"]];
            [images setImageName:[dic valueForKey:@"imageTitle"]];
            [images setImageId:imageId];
            [images setPhaseNumber:phaseNumber];
        }
    }
    return [self saveData];
}

#pragma mark - Save Home Images

- (BOOL)saveStationGalleryInfoImages:(NSDictionary *)imagesDict forKey:(NSString *)weekKey{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSString *weekDateRange = imagesDict[@"date"];
    NSString *weekCompleteKey = [NSString stringWithFormat:@"%@images", weekKey];
    NSDictionary *imagesArray = imagesDict[weekCompleteKey];
    for (NSDictionary *dic in imagesArray) {
        id imageReferenceId = [dic valueForKey:@"imageId"];
        NSString *imageId = [NSString stringWithFormat:@"%@",imageReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %@",imageId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            StationGalleryInfo *images = [NSEntityDescription insertNewObjectForEntityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
            [images setInsertDate:[AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"insertDate"]]];
            [images setImagePath:[dic valueForKey:@"imagePath"]];
            [images setStationName:[dic valueForKey:@"stationName"]];
            [images setImageName:[dic valueForKey:@"imageTitle"]];
            [images setImageId:imageId];
            [images setGalleryWeek:weekDateRange];
            [images setWeekNumber:weekKey];
        }
    }
    if (imagesArray.count == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"galleryWeek == %@",weekDateRange];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            StationGalleryInfo *images = [NSEntityDescription insertNewObjectForEntityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
            [images setGalleryWeek:weekDateRange];
            [images setWeekNumber:weekKey];
        }
    }
    return [self saveData];
}

- (BOOL)saveQueries:(NSArray *)queriesData forStation:(NSString *)stationName {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QueriesData" inManagedObjectContext:moc];
    [request setEntity:entity];

    for (NSDictionary *dict in queriesData) {
        NSString *topicArea = [dict valueForKey:@"topicArea"];
        NSArray *query = [dict valueForKey:@"query"];
        for (NSDictionary *queryDict in query) {
            NSString *name = [queryDict valueForKey:@"name"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && stationName == %@",name, stationName];
            [request setPredicate:predicate];
            NSArray *array = [moc executeFetchRequest:request error:nil];
            if (array.count == 0) {
                QueriesData *queriesData = [NSEntityDescription insertNewObjectForEntityForName:@"QueriesData" inManagedObjectContext:moc];
                [queriesData setName:name];
                [queriesData setStationName:stationName];
                [queriesData setTopicArea:topicArea];
                [queriesData setDateReceived:[AppUtilityClass getDateFromMiliSeconds:[queryDict valueForKey:@"dateReceived"]]];
                [queriesData setDateResponded:[AppUtilityClass getDateFromMiliSeconds:[queryDict valueForKey:@"dateResponded"]]];
                [queriesData setResponse:[[queryDict valueForKey:@"response"] boolValue]];
            }
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
        NSDate *createDateIdentifier = [AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"createDate"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate == %@",createDateIdentifier];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array.count == 0) {
            WhatsNewMessages *messages = [NSEntityDescription insertNewObjectForEntityForName:@"WhatsNewMessages" inManagedObjectContext:moc];
            [messages setMessage:[dic valueForKey:@"message"]];
            [messages setDesignation:[dic valueForKey:@"designation"]];
            [messages setCreateDate:[AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"createDate"]]];
            [messages setStationName:[dic valueForKey:@"stationName"]];
            [messages setMessageId:[dic valueForKey:@"messageId"]];
            [messages setDeleteMessage:[[dic valueForKey:@"deleteMessage"] boolValue]];
            [messages setUsername:[dic valueForKey:@"username"]];
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
        id tasksReferenceId = [dic valueForKey:@"refId"];
        NSString *refId = [NSString stringWithFormat:@"%@",tasksReferenceId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"refId == %@",refId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        Tasks *tasks;
        if (array.count == 0) {
            tasks = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:moc];
        }else {
            tasks = (Tasks *)[array firstObject];
        }
        [tasks setDomain:[dic valueForKey:@"domain"]];
        [tasks setEventName:[dic valueForKey:@"eventName"]];
        [tasks setRefId:refId];
        [tasks setStatus:[[dic valueForKey:@"status"] integerValue]];
        [tasks setStationId:stationId];
    }
    return [self saveData];
}

#pragma mark - Save Station sub tasks

- (BOOL)saveSubTasks:(NSArray *)subTasks forTaskId:(NSString *)taskId{
    //NSLog(@"Task ID = %@", taskId);
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubTasks" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in subTasks) {
        id stationSubActivityIdentifier = [dic valueForKey:@"stationSubActivityId"];
        NSString *stationSubActivityId = [NSString stringWithFormat:@"%@",stationSubActivityIdentifier];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationSubActivityId == %@",stationSubActivityId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        SubTasks *subTasksObject;
        if (array.count == 0) {
            subTasksObject = [NSEntityDescription insertNewObjectForEntityForName:@"SubTasks" inManagedObjectContext:moc];
        }else {
            subTasksObject = (SubTasks *)[array firstObject];
        }
        [subTasksObject setName:[dic valueForKey:@"name"]];
        [subTasksObject setStationSubActivityId:stationSubActivityId];
        [subTasksObject setExecuteAgency:[dic valueForKey:@"executeAgency"]];
        [subTasksObject setDeadline:[dic valueForKey:@"deadline"]];
        [subTasksObject setTaskId:taskId];
        [subTasksObject setStatus:[[dic valueForKey:@"status"] integerValue]];
        [subTasksObject setSortDate:[[dic valueForKey:@"sortDate"] intValue]];
        
        if ([dic[@"remarks"] isKindOfClass:[NSArray class]]) {
            NSArray *subTasksDataSource = dic[@"remarks"];
            [[CoreDataManager sharedManager] saveRemarks:subTasksDataSource forSubActivityId:stationSubActivityId];
        }
    }
    return [self saveData];
}

#pragma mark - Save Station sub tasks

- (BOOL)saveRemarks:(NSArray *)remarks forSubActivityId:(NSString *)stationSubActivityId{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Remarks" inManagedObjectContext:moc];
    [request setEntity:entity];
    for (NSDictionary *dic in remarks) {
        id remarksIdentifier = [dic valueForKey:@"remarkId"];
        NSString *remarksId = [NSString stringWithFormat:@"%@",remarksIdentifier];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remarksId == %@",remarksId];
        [request setPredicate:predicate];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        Remarks *remarks;
        if (array.count == 0) {
            remarks = [NSEntityDescription insertNewObjectForEntityForName:@"Remarks" inManagedObjectContext:moc];
        }else {
            remarks = (Remarks *)[array firstObject];
        }
//        [remarks setInsertDate:[AppUtilityClass getDateFromMiliSeconds:[dic valueForKey:@"insertDate"]]];
        [remarks setRemarksId:[dic valueForKey:@"remarkId"]];
        [remarks setMessage:[dic valueForKey:@"remark"]];
//        [remarks setStatus:[[dic valueForKey:@"status"] integerValue]];
        [remarks setTaskId:stationSubActivityId];
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

- (NSArray *)fetchAllSignUpStations {
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
#pragma mark - Fetch Stations

- (NSArray *)fetchAllStations {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"stationName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationName != %@",@"NA"];
    [request setPredicate:predicate];
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
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
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
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"insertDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}
#pragma mark - fetch station Gallery Images

- (NSArray *)fetchStationGalleryImagesForKey:(NSString*)weekKey forStationName:(NSString *)stationName{
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StationGalleryInfo" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weekNumber == %@ AND stationName == %@",weekKey, stationName];
    [request setPredicate:predicate];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"insertDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

- (NSArray *)fetchStationsSubTasksForTaskId:(NSString *)taskId {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubTasks" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId == %@",taskId];
    [request setPredicate:predicate];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"sortDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

- (NSArray *)fetchRemarksFor:(NSString *)stationSubActivityId {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Remarks" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId == %@",stationSubActivityId];
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

- (void)deleteWallMessage:(Messages *)message {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Messages" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"messageId == %@", message.messageId];
    [request setPredicate:predicate];
    //... add sorts if you want them
    NSError *fetchError;
    NSArray *fetchedProducts=[moc executeFetchRequest:request error:&fetchError];
    
    for (NSManagedObject *product in fetchedProducts) {
        [moc deleteObject:product];
    }
    [self saveData];
}

- (void)deleteWhatsNewMessage:(WhatsNewMessages *)message {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WhatsNewMessages" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"messageId == %@", message.messageId];
    [request setPredicate:predicate];
    //... add sorts if you want them
    NSError *fetchError;
    NSArray *fetchedProducts=[moc executeFetchRequest:request error:&fetchError];
    
    for (NSManagedObject *product in fetchedProducts) {
        [moc deleteObject:product];
    }
    [self saveData];
}

- (NSArray *)fetchQueriesForStationName:(NSString *)stationName {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QueriesData" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationName == %@", stationName];
    [request setPredicate:predicate];
    NSSortDescriptor *queries = [NSSortDescriptor sortDescriptorWithKey:@"topicArea" ascending:NO];
    [request setSortDescriptors:@[queries]];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

- (NSArray *)fetchQueriesForTopicArea:(NSString *)topicArea {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QueriesData" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicArea == %@", topicArea];
    [request setPredicate:predicate];
    NSSortDescriptor *queries = [NSSortDescriptor sortDescriptorWithKey:@"dateReceived" ascending:NO];
    [request setSortDescriptors:@[queries]];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

- (NSArray *)fetchIRSDCAllStations {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptorGroup = [[NSSortDescriptor alloc] initWithKey:@"stationName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptorGroup];
    [request setSortDescriptors:sortDescriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phaseNumber == %ld", kIRSDCType];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    return  result;
}

#pragma mark - Saving data

- (BOOL)saveData {
    return [self saveContext];
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [[self managedObjectContext] deleteObject:managedObject];
        //NSLog(@"%@ object deleted",entityDescription);
    }
    if (![[self managedObjectContext] save:&error]) {
        //NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

@end

