//
//  StationGalleryInfo+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "StationGalleryInfo+CoreDataProperties.h"

@implementation StationGalleryInfo (CoreDataProperties)

+ (NSFetchRequest<StationGalleryInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StationGalleryInfo"];
}

@dynamic addedDate;
@dynamic galleryWeek;
@dynamic imageId;
@dynamic imageName;
@dynamic imagePath;
@dynamic stationName;

@end
