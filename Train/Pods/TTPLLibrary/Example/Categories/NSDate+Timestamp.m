//
//  NSDate+Timestamp.m
//  PICentrix
//
//  Created by Selvin on 11/25/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import "NSDate+Timestamp.h"

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key)                                     \
  NSLocalizedStringFromTableInBundle(                                          \
      key, @"NSDateTimeAgo",                                                   \
      [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath]           \
                                   stringByAppendingPathComponent:             \
                                       @"NSDateTimeAgo.bundle"]],              \
      nil)
#endif

@implementation NSDate (Timestamp)

- (NSString *)timeStamp {
  NSDate *now = [NSDate date];
  double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
  double deltaMinutes = deltaSeconds / 60.0f;

  int minutes;

  if (deltaSeconds < 5) {
    return NSDateTimeAgoLocalizedStrings(@"Just now");
  } else if (deltaSeconds < 60) {
    return [self stringFromFormat:@"%%d %@seconds ago" withValue:deltaSeconds];
  } else if (deltaSeconds < 120) {
    return NSDateTimeAgoLocalizedStrings(@"A minute ago");
  } else if (deltaMinutes < 60) {
    return [self stringFromFormat:@"%%d %@minutes ago" withValue:deltaMinutes];
  } else if (deltaMinutes < 120) {
    return NSDateTimeAgoLocalizedStrings(@"An hour ago");
  } else if (deltaMinutes < (24 * 60)) {
    minutes = (int)floor(deltaMinutes / 60);
    return [self stringFromFormat:@"%%d %@hours ago" withValue:minutes];
  } else if (deltaMinutes < (24 * 60 * 2)) {
    return NSDateTimeAgoLocalizedStrings(@"Yesterday");
  } else if (deltaMinutes < (24 * 60 * 7)) {
    minutes = (int)floor(deltaMinutes / (60 * 24));
    return [self stringFromFormat:@"%%d %@days ago" withValue:minutes];
  } else if (deltaMinutes < (24 * 60 * 14)) {
    return NSDateTimeAgoLocalizedStrings(@"Last week");
  } else if (deltaMinutes < (24 * 60 * 31)) {
    minutes = (int)floor(deltaMinutes / (60 * 24 * 7));
    return [self stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
  } else if (deltaMinutes < (24 * 60 * 61)) {
    return NSDateTimeAgoLocalizedStrings(@"Last month");
  } else if (deltaMinutes < (24 * 60 * 365.25)) {
    minutes = (int)floor(deltaMinutes / (60 * 24 * 30));
    return [self stringFromFormat:@"%%d %@months ago" withValue:minutes];
  } else if (deltaMinutes < (24 * 60 * 731)) {
    return NSDateTimeAgoLocalizedStrings(@"Last year");
  }

  minutes = (int)floor(deltaMinutes / (60 * 24 * 365));
  return [self stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

- (NSString *)stringFromFormat:(NSString *)format withValue:(NSInteger)value {
  NSString *localeFormat = [NSString
      stringWithFormat:format,
                       [self getLocaleFormatUnderscoresWithValue:value]];
  return [NSString
      stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

- (NSString *)timestampWithLimit {

  NSCalendar *cal =
      [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  [cal setTimeZone:[NSTimeZone systemTimeZone]];

  NSDateComponents *comp = [cal
      components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                  NSHourCalendarUnit | NSMinuteCalendarUnit)
        fromDate:[NSDate date]];

  [comp setMinute:0];
  [comp setHour:0];

  NSDate *startOfToday = [cal dateFromComponents:comp];
  NSTimeInterval limit = [[NSDate date] timeIntervalSinceDate:startOfToday];

  if (fabs([self timeIntervalSinceDate:[NSDate date]]) >= limit)
    return [self timeStamp];

  return [NSDateFormatter localizedStringFromDate:self
                                        dateStyle:NSDateFormatterNoStyle
                                        timeStyle:NSDateFormatterShortStyle];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d
 секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012

 Note    : This method must be used for all languages that have specific
 translation rules.
 Using method argument "value" you must define all possible conditions language
 have for translation
 and return set of underscores ("_") as it is an ID for locale format. No
 underscore ("") means default locale format;
 */
- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value {
  NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];

  // Russian (ru)
  if ([localeCode isEqual:@"ru"]) {
    int XY = (int)floor(value) % 100;
    int Y = (int)floor(value) % 10;

    if (Y == 0 || Y > 4 || (XY > 10 && XY < 15))
      return @"";
    if (Y > 1 && Y < 5 && (XY < 10 || XY > 20))
      return @"_";
    if (Y == 1 && XY != 11)
      return @"__";
  }

  // Add more languages here, which are have specific translation rules...

  return @"";
}

#pragma clang diagnostic pop

@end
