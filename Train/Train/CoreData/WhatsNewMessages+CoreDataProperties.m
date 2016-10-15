//
//  WhatsNewMessages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/15/16.
//
//

#import "WhatsNewMessages+CoreDataProperties.h"

@implementation WhatsNewMessages (CoreDataProperties)

+ (NSFetchRequest<WhatsNewMessages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WhatsNewMessages"];
}

@dynamic stationName;
@dynamic designation;
@dynamic message;
@dynamic username;
@dynamic createDate;
@dynamic addedDate;

@end
