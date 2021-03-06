//
//  HomeImages+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "HomeImages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomeImages (CoreDataProperties)

+ (NSFetchRequest<HomeImages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *insertDate;
@property (nullable, nonatomic, copy) NSString *imageId;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *imagePath;
@property (nullable, nonatomic, copy) NSString *stationName;
@property (nonatomic) int16_t phaseNumber;

@end

NS_ASSUME_NONNULL_END
