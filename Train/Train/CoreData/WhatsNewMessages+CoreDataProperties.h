//
//  WhatsNewMessages+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/15/16.
//
//

#import "WhatsNewMessages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WhatsNewMessages (CoreDataProperties)

+ (NSFetchRequest<WhatsNewMessages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *stationName;
@property (nullable, nonatomic, copy) NSString *designation;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSDate *addedDate;

@end

NS_ASSUME_NONNULL_END
