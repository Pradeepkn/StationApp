//
//  Designation+CoreDataProperties.m
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "Designation+CoreDataProperties.h"

@implementation Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Designation"];
}

@dynamic designationName;
@dynamic designationId;

@end
