//
//  Designation+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Designation+CoreDataProperties.h"

@implementation Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Designation"];
}

@dynamic designationId;
@dynamic designationName;

@end
