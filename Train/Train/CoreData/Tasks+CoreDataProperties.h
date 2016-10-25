//
//  Tasks+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Tasks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tasks (CoreDataProperties)

+ (NSFetchRequest<Tasks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *domain;
@property (nullable, nonatomic, copy) NSString *eventName;
@property (nullable, nonatomic, copy) NSString *refId;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nonatomic) int16_t status;

@end

NS_ASSUME_NONNULL_END
