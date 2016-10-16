//
//  Remarks+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Remarks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Remarks (CoreDataProperties)

+ (NSFetchRequest<Remarks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *taskId;
@property (nullable, nonatomic, copy) NSString *insertDate;
@property (nullable, nonatomic, copy) NSString *remarksId;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int16_t status;

@end

NS_ASSUME_NONNULL_END
