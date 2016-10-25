//
//  SubTasks+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "SubTasks+CoreDataProperties.h"

@implementation SubTasks (CoreDataProperties)

+ (NSFetchRequest<SubTasks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SubTasks"];
}

@dynamic deadline;
@dynamic executeAgency;
@dynamic name;
@dynamic stationSubActivityId;
@dynamic status;
@dynamic taskId;

@end
