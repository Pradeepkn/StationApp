//
//  Designation+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Designation+CoreDataProperties.h"

@implementation Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Designation"];
}

@dynamic designationId;
@dynamic designationName;
@dynamic phaseNumber;

@end
