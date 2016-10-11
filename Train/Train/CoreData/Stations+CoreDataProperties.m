//
//  Stations+CoreDataProperties.m
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "Stations+CoreDataProperties.h"

@implementation Stations (CoreDataProperties)

+ (NSFetchRequest<Stations *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Stations"];
}

@dynamic stationName;
@dynamic stationId;

@end
