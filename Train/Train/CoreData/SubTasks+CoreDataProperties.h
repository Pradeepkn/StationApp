//
//  SubTasks+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "SubTasks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SubTasks (CoreDataProperties)

+ (NSFetchRequest<SubTasks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deadline;
@property (nullable, nonatomic, copy) NSString *executeAgency;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *stationSubActivityId;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *taskId;

@end

NS_ASSUME_NONNULL_END
