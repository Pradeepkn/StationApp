//
//  NSString+LocalizedString.m
//  TelenorX
//
//  Created by Pradi.K.N on 8/12/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import "NSString+LocalizedString.h"

@implementation NSString (LocalizedString)

+ (NSString *)localizedValueForKey :(NSString*)key{
    NSString *value = NSLocalizedString(key, key);
    return value;
}
@end
