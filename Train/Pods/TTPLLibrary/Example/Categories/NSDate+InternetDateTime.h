//
//  NSDate+InternetDateTime.h
//  MWFeedParser
//
//  Created by Michael Waterfall on 07/10/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import <Foundation/Foundation.h>

// Date format hints for parsing date from internet string
typedef enum {DateFormatHintNone, DateFormatHintRFC822, DateFormatHintRFC3339} DateFormatHint;

@interface NSDate (InternetDateTime)
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString formatHint:(DateFormatHint)hint;
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString;
+ (NSDate *)dateFromRFC822String:(NSString *)dateString;

+ (NSDate*)dateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
- (NSDate*)dateWithDateOnly;

- (NSInteger)numOfDaysInMonth;
- (NSDate*)firstDayInMonth;
- (NSDate*)lastDayInMonth;

- (NSDate*)nextMonth;
- (NSDate*)previousMonth;

- (NSDate*)nextDay;
- (NSDate*)previousDay;

- (NSInteger)minute;
- (NSInteger)hour;
- (NSInteger)day;
- (NSInteger)weekDay;
- (NSInteger)month;
- (NSInteger)year;

- (NSString *)shortMonthName;
- (NSString *)fullMonthName;

- (BOOL)isEqualToDateWithoutTime:(NSDate*)otherDate;

@end
