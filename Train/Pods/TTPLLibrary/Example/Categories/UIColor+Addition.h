//
//  UIColor+Addition.h
//  PICentrix
//
//  Created by Subramanian on 12/5/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

/*
 @abstract Returns UIColor of the given Hexadecimal string (ex: #8674AF)

 @discussion Returns UIColor of the given Hexadecimal string (ex: #8674AF)

 @return Returns instance of UIColor

 @since 1.0+
 */

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
