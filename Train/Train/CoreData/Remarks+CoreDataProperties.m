//
//  Remarks+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Remarks+CoreDataProperties.h"

@implementation Remarks (CoreDataProperties)

+ (NSFetchRequest<Remarks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Remarks"];
}

@dynamic insertDate;
@dynamic message;
@dynamic remarksId;
@dynamic status;
@dynamic taskId;

@end
