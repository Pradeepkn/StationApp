//
//  WhatsNewMessages+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "WhatsNewMessages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WhatsNewMessages (CoreDataProperties)

+ (NSFetchRequest<WhatsNewMessages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *designation;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *messageId;
@property (nullable, nonatomic, copy) NSString *stationName;
@property (nullable, nonatomic, copy) NSString *username;
@property (nonatomic) BOOL deleteMessage;

@end

NS_ASSUME_NONNULL_END
