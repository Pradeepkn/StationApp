//
//  Tasks+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Tasks+CoreDataProperties.h"

@implementation Tasks (CoreDataProperties)

+ (NSFetchRequest<Tasks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
}

@dynamic domain;
@dynamic eventName;
@dynamic refId;
@dynamic status;
@dynamic stationId;

@end
