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

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

- (BOOL)saveStations:(NSArray *)stations ;
- (BOOL)saveDesignations:(NSArray *)designations;
- (BOOL)saveLogedInUser:(NSDictionary *)logedInDict;
- (BOOL)saveMessages:(NSArray *)messages;
- (BOOL)saveHomeImages:(NSArray *)images;
- (BOOL)saveWhatsNewMessages:(NSArray *)whatsNewMessages;
- (BOOL)saveStationTasks:(NSArray *)stationTasks  forStationId:(NSString *)stationId;
- (BOOL)saveSubTasks:(NSArray *)subTasks forTaskId:(NSString *)taskId;
- (BOOL)saveRemarks:(NSArray *)remarks forTaskId:(NSString *)taskId;
- (BOOL)saveStationGalleryInfoImages:(NSArray *)images forKey:(NSString *)weekKey;

- (User *)fetchLogedInUser;
- (NSArray *)fetchAllStations ;
- (NSArray *)fetchAllDesignation;
- (NSArray *)fetchHomeMessages;
- (NSArray *)fetchHomeImages;
- (NSArray *)fetchWhatsNewMessages;
- (NSArray *)fetchStationGalleryImagesForKey:(NSString*)weekKey;

- (BOOL)saveData;

@end

