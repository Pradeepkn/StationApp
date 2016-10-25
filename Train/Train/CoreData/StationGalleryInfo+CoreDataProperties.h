//
//  StationGalleryInfo+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "StationGalleryInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StationGalleryInfo (CoreDataProperties)

+ (NSFetchRequest<StationGalleryInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *addedDate;
@property (nullable, nonatomic, copy) NSString *galleryWeek;
@property (nullable, nonatomic, copy) NSString *imageId;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imagePath;
@property (nullable, nonatomic, copy) NSString *stationName;

@end

NS_ASSUME_NONNULL_END
