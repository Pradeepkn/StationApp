//
//  NSArray+Additions.m
//  Egmont
//
//  Created by Selvin on 3/19/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSMutableArray *)filteredArrayUsingBlock:(BOOL (^)(id, NSUInteger, BOOL *))predicate{
    NSIndexSet * filteredIndexes = [self indexesOfObjectsPassingTest:predicate];
    return [[self objectsAtIndexes:filteredIndexes]mutableCopy];
}

- (NSArray*)filteredSubArrayUsingBlock:(id(^)(id))filter{
    // The purpose of this method is to filter the sub elements of the array
    NSMutableArray *elementFilter = [NSMutableArray new];
    for (id obj in self) {
        [elementFilter addObject:filter(obj)];
    }
    return [elementFilter copy];
}

@end
