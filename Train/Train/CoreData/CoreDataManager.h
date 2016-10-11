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

@interface CoreDataManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)saveStations:(NSArray *)stations ;
- (BOOL)saveDesignations:(NSArray *)designations;

- (NSArray *)fetchAllStations ;
- (NSArray *)fetchAllDesignation;

- (BOOL)saveData;

@end

