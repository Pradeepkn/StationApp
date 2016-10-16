//
//  Designation+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/16/16.
//
//

#import "Designation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *designationId;
@property (nullable, nonatomic, copy) NSString *designationName;

@end

NS_ASSUME_NONNULL_END
