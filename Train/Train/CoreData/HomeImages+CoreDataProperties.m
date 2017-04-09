//
//  HomeImages+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "HomeImages+CoreDataProperties.h"

@implementation HomeImages (CoreDataProperties)

+ (NSFetchRequest<HomeImages *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HomeImages"];
}

@dynamic insertDate;
@dynamic imageId;
@dynamic imageName;
@dynamic imagePath;
@dynamic stationName;
@dynamic phaseNumber;

@end
