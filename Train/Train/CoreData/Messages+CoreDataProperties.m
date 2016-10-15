//
//  Messages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/15/16.
//
//

#import "Messages+CoreDataProperties.h"

@implementation Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
}

@dynamic designation;
@dynamic message;
@dynamic createDate;
@dynamic addedDate;

@end
