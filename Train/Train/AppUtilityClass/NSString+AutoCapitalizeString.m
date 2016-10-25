//
//  NSString+AutoCapitalizeString.m
//  Train
//
//  Created by Pradeep Narendra on 10/25/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "NSString+AutoCapitalizeString.h"

@implementation NSString (AutoCapitalizeString)

+ (NSString *)autoCapitalize:(NSString *)string {
    string = [NSString stringWithFormat:@"%@%@",[[string substringToIndex:1] uppercaseString],[string substringFromIndex:1] ];
    return string;
}
@end
