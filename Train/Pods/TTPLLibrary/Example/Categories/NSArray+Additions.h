//
//  NSArray+Additions.h
//  Egmont
//
//  Created by Selvin on 3/19/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief Additional features for NSArray
 * @class NSArray+Additions
 * @author Selvin
 * @version 1.0
 */
@interface NSArray (Additions)

/**
 * @brief Filter an NSArray based on a block predicate
 * @param predicate predicate block
 * @return filtered array mutable
 */
- (NSMutableArray *)filteredArrayUsingBlock:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

/**
 * @brief Filter an NSArray SubArray based on a block filter
 * @param filter a filter block
 * @return filtered array non mutable
 */
- (NSArray*)filteredSubArrayUsingBlock:(id(^)(id))filter;

@end
