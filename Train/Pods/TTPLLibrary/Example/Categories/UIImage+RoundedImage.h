//
//  UIImage+RoundedImage.h
//  TelenorX
//
//  Created by Ashish Srivastava on 13/08/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedImage)

+ (UIImage *)roundedImageFromImage:(UIImage *)image;


+ (UIImage *)circularScaleNCrop:(UIImage*)image rect:(CGRect)rect;

@end
