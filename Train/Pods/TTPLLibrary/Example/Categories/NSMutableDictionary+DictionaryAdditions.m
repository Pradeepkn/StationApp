//
//  NSMutableDictionary+DictionaryAdditions.m
//  Egmont
//
//  Created by Suraj Sundar on 09/05/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import "NSMutableDictionary+DictionaryAdditions.h"

@implementation NSMutableDictionary (DictionaryAdditions)
-(void)removeNullValues{
	for(NSString *key in [self allKeys]){
		if([self[key] isKindOfClass:[NSNull class]]){
			self[key] = @"";
		}
	}
}
@end
