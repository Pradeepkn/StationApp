//
//  Designation+CoreDataProperties.h
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "Designation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Designation (CoreDataProperties)

+ (NSFetchRequest<Designation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *designationName;
@property (nullable, nonatomic, copy) NSString *designationId;

@end

NS_ASSUME_NONNULL_END
