//
//  UIImage+ImageAdditions.h
//
//
//  Created by Suraj Sundar on 11/03/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageAdditions)

/**
 * @brief This method is used to resize an image according to the size of the
 * Image View it is displayed on
 * @param UIImage, CGSize
 * @return UIImage
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 * @brief This method is used to crop the center of the Image
 * @param
 * @return UIImage
 */
- (UIImage *)croppedImage;

/*!
 @abstract Crop image from the center of the image with the given proposition in
 a square shape.
 @discussion Crop image from the center of the image with the given proposition
 in a square shape.
 @param sourceImage Source image which need to crop
 @return Returns the cropped image.
 @since 1.0+
 */
+ (UIImage *)squareCropImageToSideLength:(UIImage *)sourceImage
                                  length:(CGFloat)sideLength;

/*!
 @abstract Takes a square shaped image and returns a circular image.

 @return A circular image

 @since 1.0
 */
- (UIImage *)circularImage;

/*!
 @abstract Use the base image and fill specified color on top of the existing
 area. To return a new image with given color.

 @param theColor The UIColor on which the base image is to be colorized.

 @return New Image with the given color.

 @since 1.0
 */
- (UIImage *)colorizeImage:(UIColor *)theColor;
@end
