//
//  NSString+Additions.m
//  Egmont
//
//  Created by Selvin on 3/7/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSInteger)ageFromString {
    //This is a sample date. The Z stands for GMT timezone
    //The 0901 is 09h 01m on a 24 hour clock not 12.
    //As long as I can get the hours/min & date from the string I can deal with the time zone later
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthdate = [dateFormat dateFromString:self];
    if (birthdate) {
        return [self ageFromBirthday:birthdate];
    }
    return 0;
}

- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}

@end
