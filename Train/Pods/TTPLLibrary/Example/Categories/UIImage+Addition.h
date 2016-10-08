//
//  UIImage+Addition.h
//  BigRedStop
//
//  Created by Selvin on 7/7/14.
//  Copyright (c) 2014 Selvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

/**
 * @brief
 * @param firstImage the image on LHS
 * @param secondImage the image on RHS
 * @return combined image
 */
+ (UIImage *)firstImage:(UIImage *)leftImage secondImage:(UIImage *)rightImage;

/**
 * @brief to return a 1x1 image with given color
 * @param color the color to be created
 * @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)separatorWithColor:(UIColor *)color;

@end
