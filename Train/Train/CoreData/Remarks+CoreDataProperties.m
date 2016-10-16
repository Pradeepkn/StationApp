//
//  Remarks+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Remarks+CoreDataProperties.h"

@implementation Remarks (CoreDataProperties)

+ (NSFetchRequest<Remarks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Remarks"];
}

@dynamic taskId;
@dynamic insertDate;
@dynamic remarksId;
@dynamic message;
@dynamic status;

@end
