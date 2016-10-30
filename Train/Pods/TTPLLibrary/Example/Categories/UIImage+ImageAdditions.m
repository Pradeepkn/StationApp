//
//  UIImage+ImageAdditions.m
//
//
//  Created by Suraj Sundar on 11/03/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import "UIImage+ImageAdditions.h"

@implementation UIImage (ImageAdditions)


- (UIImage *)scaleImageToSize:(CGSize)newSize {
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIImage *sourceImage = image;
  UIImage *newImage = nil;

  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;

  CGFloat targetWidth = newSize.width + 150;
  CGFloat targetHeight = newSize.height + 60;

  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;

  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  if (CGSizeEqualToSize(imageSize, newSize) == NO) {

    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;

    if (widthFactor < heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;

    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;

    // center the image

    if (widthFactor < heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.15;
    } else if (widthFactor > heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.05;
    }
  }

  // this is actually the interesting part:

  UIGraphicsBeginImageContext(newSize);

  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width = scaledWidth;
  thumbnailRect.size.height = scaledHeight;

  [sourceImage drawInRect:thumbnailRect];

  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  if (newImage == nil)
    NSLog(@"could not scale image");

  return newImage;
}

- (UIImage *)croppedImage {
  UIImage *ret = nil;

  // This calculates the crop area.

  float originalWidth = self.size.width * self.scale;
  float originalHeight = self.size.height * self.scale;

  float edge = fminf(originalWidth, originalHeight);

  float posX = (originalWidth - edge) / 2.0f;
  float posY = (originalHeight - edge) / 2.0f;

  CGRect cropSquare = CGRectMake(posX, posY, edge, edge);

  // This performs the image cropping.

  CGImageRef imageRef =
      CGImageCreateWithImageInRect([self CGImage], cropSquare);

  ret = [UIImage imageWithCGImage:imageRef
                            scale:self.scale
                      orientation:self.imageOrientation];

  CGImageRelease(imageRef);

  return ret;
}

- (UIImage *)circularImage {
  CALayer *imageLayer = [CALayer layer];
  imageLayer.frame = CGRectMake(0, 0, self.size.width * self.scale,
                                self.size.height * self.scale);
  imageLayer.contents = (id)self.CGImage;

  imageLayer.masksToBounds = YES;
  imageLayer.cornerRadius = self.size.width / 2.0;

  UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
  [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return roundedImage;
}

+ (UIImage *)squareCropImageToSideLength:(UIImage *)sourceImage
                                  length:(CGFloat)sideLength {
  // input size comes from image
  CGSize inputSize = sourceImage.size;

  // round up side length to avoid fractional output size
  sideLength = ceilf(sideLength);

  // output size has sideLength for both dimensions
  CGSize outputSize = CGSizeMake(sideLength, sideLength);

  // calculate scale so that smaller dimension fits sideLength
  CGFloat scale =
      MAX(sideLength / inputSize.width, sideLength / inputSize.height);

  // scaling the image with this scale results in this output size
  CGSize scaledInputSize =
      CGSizeMake(inputSize.width * scale, inputSize.height * scale);

  // determine point in center of "canvas"
  CGPoint center = CGPointMake(outputSize.width / 2.0, outputSize.height / 2.0);

  // calculate drawing rect relative to output Size
  CGRect outputRect = CGRectMake(center.x - scaledInputSize.width / 2.0,
                                 center.y - scaledInputSize.height / 2.0,
                                 scaledInputSize.width, scaledInputSize.height);

  // begin a new bitmap context, scale 0 takes display scale
  UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);

  // optional: set the interpolation quality.
  // For this you need to grab the underlying CGContext
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);

  // draw the source image into the calculated rect
  [sourceImage drawInRect:outputRect];

  // create new image from bitmap context
  UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();

  // clean up
  UIGraphicsEndImageContext();

  // pass back new image
  return outImage;
}

- (UIImage *)colorizeImage:(UIColor *)theColor {
  // initiate the drawing context
  UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

  // prepare context to draw on top of the existing base image
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  CGContextSaveGState(ctx);
  CGContextClipToMask(ctx, area, self.CGImage);
  [theColor set];

  // Fill the color in the area
  CGContextFillRect(ctx, area);
  CGContextRestoreGState(ctx);
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  CGContextDrawImage(ctx, area, self.CGImage);

  // cut the context and load it in to the UIImage
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return newImage;
}

@end
