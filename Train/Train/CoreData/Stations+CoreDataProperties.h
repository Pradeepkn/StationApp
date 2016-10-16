//
//  Stations+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Stations+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Stations (CoreDataProperties)

+ (NSFetchRequest<Stations *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *stationName;
@property (nonatomic) int16_t statusColor;

@end

NS_ASSUME_NONNULL_END
