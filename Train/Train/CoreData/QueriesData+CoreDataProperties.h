//
//  QueriesData+CoreDataProperties.h
//  Train
//
//  Created by pradeep on 4/11/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "QueriesData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QueriesData (CoreDataProperties)

+ (NSFetchRequest<QueriesData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateReceived;
@property (nullable, nonatomic, copy) NSDate *dateResponded;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL response;
@property (nullable, nonatomic, copy) NSString *stationName;
@property (nullable, nonatomic, copy) NSString *topicArea;

@end

NS_ASSUME_NONNULL_END
