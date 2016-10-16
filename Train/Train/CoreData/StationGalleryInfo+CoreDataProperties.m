//
//  StationGalleryInfo+CoreDataProperties.m
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "StationGalleryInfo+CoreDataProperties.h"

@implementation StationGalleryInfo (CoreDataProperties)

+ (NSFetchRequest<StationGalleryInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StationGalleryInfo"];
}

@dynamic addedDate;
@dynamic imageId;
@dynamic imageName;
@dynamic imagePath;
@dynamic stationName;
@dynamic galleryWeek;

@end
