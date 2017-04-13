//
//  CoreDataManager.h
//  Eisenhower
//
//  Created by Kavya on 23/12/15.
//  Copyright © 2015 Kavya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stations+CoreDataClass.h"
#import "Designation+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Messages+CoreDataClass.h"
#import "HomeImages+CoreDataClass.h"
#import "WhatsNewMessages+CoreDataClass.h"
#import "Tasks+CoreDataClass.h"
#import "SubTasks+CoreDataClass.h"
#import "StationGalleryInfo+CoreDataClass.h"
#import "Remarks+CoreDataClass.h"
#import "QueriesData+CoreDataClass.h"

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

- (BOOL)saveStations:(NSArray *)stations forPhase:(NSInteger)phaseNumber;
- (BOOL)saveDesignations:(NSArray *)designations forPhase:(NSInteger)phaseNumber;
- (BOOL)saveLogedInUser:(NSDictionary *)logedInDict;
- (BOOL)saveMessages:(NSArray *)messages forPhase:(NSInteger)phaseNumber;
- (BOOL)saveHomeImages:(NSArray *)images forPhase:(NSInteger)phaseNumber;
- (BOOL)saveQueries:(NSArray *)queriesData forStation:(NSString *)stationName;
- (BOOL)saveWhatsNewMessages:(NSArray *)whatsNewMessages;
- (BOOL)saveStationTasks:(NSArray *)stationTasks  forStationId:(NSString *)stationId;
- (BOOL)saveSubTasks:(NSArray *)subTasks forTaskId:(NSString *)taskId;
- (BOOL)saveRemarks:(NSArray *)remarks forSubActivityId:(NSString *)stationSubActivityId;
- (BOOL)saveStationGalleryInfoImages:(NSDictionary *)imagesDict forKey:(NSString *)weekKey;

- (User *)fetchLogedInUser;
- (NSArray *)fetchAllSignUpStations;
- (NSArray *)fetchAllStations ;
- (NSArray *)fetchAllDesignation;
- (NSArray *)fetchHomeMessages;
- (NSArray *)fetchHomeImages;
- (NSArray *)fetchWhatsNewMessages;
- (NSArray *)fetchStationGalleryImagesForKey:(NSString*)weekKey forStationName:(NSString *)stationName;
- (NSArray *)fetchQueriesForStationName:(NSString *)stationName;
- (NSArray *)fetchQueriesForTopicArea:(NSString *)topicArea;
- (NSArray *)fetchStationsSubTasksForTaskId:(NSString *)taskId;
- (NSArray *)fetchRemarksFor:(NSString *)stationSubActivityId;
- (NSArray *)fetchIRSDCAllStations;
- (NSArray *)fetchIRSDCAllStationTasksForStationId:(NSString*)stationId;

- (BOOL)saveData;

- (void)deleteWallMessage:(Messages *)message;
- (void)deleteWhatsNewMessage:(WhatsNewMessages *)message;
- (void)deleteAllObjects: (NSString *) entityDescription;

@end

