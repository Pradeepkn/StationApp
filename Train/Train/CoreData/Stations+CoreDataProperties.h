//
//  Stations+CoreDataProperties.h
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "Stations+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Stations (CoreDataProperties)

+ (NSFetchRequest<Stations *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *stationName;
@property (nullable, nonatomic, copy) NSString *stationId;

@end

NS_ASSUME_NONNULL_END
