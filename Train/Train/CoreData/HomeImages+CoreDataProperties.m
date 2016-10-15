//
//  HomeImages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/15/16.
//
//

#import "HomeImages+CoreDataProperties.h"

@implementation HomeImages (CoreDataProperties)

+ (NSFetchRequest<HomeImages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HomeImages"];
}

@dynamic imagePath;
@dynamic stationName;
@dynamic imageName;
@dynamic addedDate;

@end
