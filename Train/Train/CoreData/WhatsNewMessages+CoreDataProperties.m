//
//  WhatsNewMessages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "WhatsNewMessages+CoreDataProperties.h"

@implementation WhatsNewMessages (CoreDataProperties)

+ (NSFetchRequest<WhatsNewMessages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WhatsNewMessages"];
}

@dynamic addedDate;
@dynamic createDate;
@dynamic designation;
@dynamic message;
@dynamic stationName;
@dynamic username;
@dynamic messageId;

@end
