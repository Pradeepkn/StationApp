//
//  Messages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Messages+CoreDataProperties.h"

@implementation Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Messages"];
}

@dynamic createDate;
@dynamic designation;
@dynamic message;
@dynamic messageId;
@dynamic deleteMessage;
@dynamic username;
@dynamic phaseNumber;

@end
