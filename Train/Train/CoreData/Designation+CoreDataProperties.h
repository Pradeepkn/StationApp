//
//  Designation+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Designation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *designationId;
@property (nullable, nonatomic, copy) NSString *designationName;
@property (nonatomic) int16_t phaseNumber;

@end

NS_ASSUME_NONNULL_END
