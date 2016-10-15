//
//  User+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/15/16.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic name;
@dynamic email;
@dynamic designation;
@dynamic stationName;

@end
