//
//  QueriesData+CoreDataProperties.m
//  Train
//
//  Created by pradeep on 4/11/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "QueriesData+CoreDataProperties.h"

@implementation QueriesData (CoreDataProperties)

+ (NSFetchRequest<QueriesData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QueriesData"];
}

@dynamic dateReceived;
@dynamic dateResponded;
@dynamic name;
@dynamic response;
@dynamic stationName;
@dynamic topicArea;

@end
