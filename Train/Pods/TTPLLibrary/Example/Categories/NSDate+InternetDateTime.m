//
//  NSDate+InternetDateTime.m
//  MWFeedParser
//
//  Created by Michael Waterfall on 07/10/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import "NSDate+InternetDateTime.h"

@implementation NSDate (InternetDateTime)

// Good info on internet dates here: http://developer.apple.com/iphone/library/qa/qa2010/qa1480.html

// Get a date from a string - hit (from specs) can be used to speed up
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString formatHint:(DateFormatHint)hint {
	if(![dateString isKindOfClass:[NSString class]]) return nil;
	
	NSDate *date = nil;
	if (hint != DateFormatHintRFC3339) {
		// Try RFC822 first
		date = [NSDate dateFromRFC822String:dateString];
		if (!date) date = [NSDate dateFromRFC3339String:dateString];
	} else {
		// Try RFC3339 first
		date = [NSDate dateFromRFC3339String:dateString];
		if (!date) date = [NSDate dateFromRFC822String:dateString];
	}
	return date;
}

// See http://www.faqs.org/rfcs/rfc822.html
+ (NSDate *)dateFromRFC822String:(NSString *)dateString {
	if(![dateString isKindOfClass:[NSString class]]) return nil;

	// Create date formatter
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:en_US_POSIX];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}

	// Process
	NSDate *date = nil;
	NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
	if ([RFC822String rangeOfString:@","].location != NSNotFound) {
		if (!date) { // Sun, 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // Sun, 19 May 2002 15:21
			[dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	} else {
		if (!date) { // 19 May 2002 15:21:36 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21 GMT
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21:36
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
		if (!date) { // 19 May 2002 15:21
			[dateFormatter setDateFormat:@"d MMM yyyy HH:mm"]; 
			date = [dateFormatter dateFromString:RFC822String];
		}
	}
	if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possibly invalid format.", dateString);
	return date;
	
}

// See http://www.faqs.org/rfcs/rfc3339.html
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString {
	if(![dateString isKindOfClass:[NSString class]]) return nil;
	
	// Create date formatter
	static NSDateFormatter *dateFormatter = nil;
	if (!dateFormatter) {
		NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:en_US_POSIX];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	
	// Process date
	NSDate *date = nil;
	NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
	RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
	// Remove colon in timezone as iOS 4+ NSDateFormatter breaks. See https://devforums.apple.com/thread/45837
	if (RFC3339String.length > 20) {
		RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
																 withString:@"" 
																	options:0
																	  range:NSMakeRange(20, RFC3339String.length-20)];
	}
	if (!date) { // 1996-12-19T16:39:57-0800
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27.87+0020
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) { // 1937-01-01T12:00:27
		[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
		date = [dateFormatter dateFromString:RFC3339String];
	}
	if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possibly invalid format.", dateString);
	return date;
	
}

+ (NSDate*)dateWithDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:day];
	[comps setMonth:month];
	[comps setYear:year];
	return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate*)dateWithDateOnly {
	return [NSDate dateWithDay:[self day] month:[self month] year:[self year]];
}

- (NSDate*)firstDayInMonth {
	return [NSDate dateWithDay:1 month:[self month] year:[self year]];
}

- (NSDate*)lastDayInMonth {
	return [NSDate dateWithDay:[self numOfDaysInMonth] month:[self month] year:[self year]];
}

- (NSInteger)numOfDaysInMonth {
	return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSDate*)nextMonth {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.month = +1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate*)previousMonth {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.month = -1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate*)nextDay {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = +1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate*)previousDay {
	NSDateComponents *c = [[NSDateComponents alloc] init];
	c.day = -1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSInteger)minute {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
	return parts.minute;
}

- (NSInteger)hour {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];
	return parts.hour;
}

- (NSInteger)day {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
	return parts.day;
}

- (NSInteger)weekDay
{
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
	return parts.weekday;
}

- (NSInteger)month {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
	return parts.month;
}

- (NSInteger)year {
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
	return parts.year;
}

- (NSString *)shortMonthName{
	NSString *locId = [NSString stringWithFormat:@"SHR_MONTH_%d",[self month]];
	return NSLocalizedString(locId, nil);
}

- (NSString *)fullMonthName {
	NSString *locId = [NSString stringWithFormat:@"MONTH_%d",[self month]];
	return NSLocalizedString(locId, nil);
}

- (BOOL)isEqualToDateWithoutTime:(NSDate*)otherDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar]; 
    NSDateComponents *components = [currentCalendar components:NSDayCalendarUnit fromDate:self toDate:otherDate options:0];
    
    return 0 == [components day];
}

@end
