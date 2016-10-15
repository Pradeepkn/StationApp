//
//  SubTasks+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "SubTasks+CoreDataProperties.h"

@implementation SubTasks (CoreDataProperties)

+ (NSFetchRequest<SubTasks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SubTasks"];
}

@dynamic stationSubActivityInfoRef;
@dynamic name;
@dynamic executeAgency;
@dynamic deadline;
@dynamic status;

@end
