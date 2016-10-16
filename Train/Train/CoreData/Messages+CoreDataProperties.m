//
//  Messages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Messages+CoreDataProperties.h"

@implementation Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
}

@dynamic addedDate;
@dynamic createDate;
@dynamic designation;
@dynamic message;
@dynamic messageId;

@end
