//
//  Tasks+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Tasks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tasks (CoreDataProperties)

+ (NSFetchRequest<Tasks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *domain;
@property (nullable, nonatomic, copy) NSString *eventName;
@property (nullable, nonatomic, copy) NSString *refId;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *stationId;

@end

NS_ASSUME_NONNULL_END
