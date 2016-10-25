//
//  Remarks+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Remarks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Remarks (CoreDataProperties)

+ (NSFetchRequest<Remarks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *insertDate;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *remarksId;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *taskId;

@end

NS_ASSUME_NONNULL_END
