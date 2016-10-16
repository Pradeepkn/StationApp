//
//  HomeImages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "HomeImages+CoreDataProperties.h"

@implementation HomeImages (CoreDataProperties)

+ (NSFetchRequest<HomeImages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HomeImages"];
}

@dynamic addedDate;
@dynamic imageName;
@dynamic imagePath;
@dynamic stationName;
@dynamic imageId;

@end
