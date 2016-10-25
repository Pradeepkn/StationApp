//
//  WhatsNewMessages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "WhatsNewMessages+CoreDataProperties.h"

@implementation WhatsNewMessages (CoreDataProperties)

+ (NSFetchRequest<WhatsNewMessages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WhatsNewMessages"];
}

@dynamic createDate;
@dynamic designation;
@dynamic message;
@dynamic messageId;
@dynamic stationName;
@dynamic username;
@dynamic deleteMessage;

@end
