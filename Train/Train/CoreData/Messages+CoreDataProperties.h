//
//  Messages+CoreDataProperties.h
//  
//
//  Created by Pradeep Narendra on 10/25/16.
//
//

#import "Messages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createDate;
@property (nullable, nonatomic, copy) NSString *designation;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *messageId;
@property (nonatomic) BOOL deleteMessage;
@property (nullable, nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
