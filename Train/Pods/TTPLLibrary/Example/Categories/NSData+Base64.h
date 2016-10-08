//
//  NSData+Base64.h
//  Egmont
//
//  Created by Selvin on 3/7/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

/**
 * @brief Create a base64 encoded string of given NSData
 * @param -
 * @return Base64 encode NSString*
 */
- (NSString *)base64String;

@end
