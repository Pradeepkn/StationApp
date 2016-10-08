//
//  UIImage+Addition.m
//  BigRedStop
//
//  Created by Selvin on 7/7/14.
//  Copyright (c) 2014 Selvin. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

// concatenate 2 images and give them back as one
+ (UIImage *)firstImage:(UIImage *)leftImage secondImage:(UIImage *)rightImage {
  CGFloat height = (leftImage.size.height > rightImage.size.height)
                       ? leftImage.size.height
                       : rightImage.size.height;
  CGFloat width = leftImage.size.width + rightImage.size.width;
  CGSize size = (CGSize) {.height = height, .width = width};
  UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
  [leftImage
      drawInRect:CGRectMake(0, (height / 2) - (leftImage.size.height / 2),
                            leftImage.size.width, leftImage.size.height)];
  [rightImage
      drawInRect:CGRectMake(leftImage.size.width + 1, 0, rightImage.size.width,
                            rightImage.size.height)];
  UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return destImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

+ (UIImage *)separatorWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  // draw the top half with given color
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, CGRectMake(0, 0, 1.0, 0.5));

  // draw the bottom half with clear color
  CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
  CGContextFillRect(context, CGRectMake(0, 0.5, 1.0, 0.5));

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end
