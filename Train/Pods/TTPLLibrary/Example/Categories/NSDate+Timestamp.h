//
//  NSDate+Timestamp.h
//  PICentrix
//
//  Created by Selvin on 11/25/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Timestamp)

/*!
 @abstract Returns fuzzy time from the given NSDate using some logic.

 @discussion This category needs another Pod to properly work. "NSDate+Timeago".

 @return Fuzzy timestamp string

 @warning Please do not remove "NSDate+Timeago" from pods. This category uses
 the bundle resource from that pod.

 @since 1.0
 */
- (NSString *)timestampWithLimit;

@end
