//
//  UIImage+RoundedImage.m
//  TelenorX
//
//  Created by Ashish Srivastava on 13/08/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import "UIImage+RoundedImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (RoundedImage)

+ (UIImage *)roundedImageFromImage:(UIImage *)image {
    if (image) {
        CGContextRef cr = CGBitmapContextCreate(NULL, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage));
        
        CGContextBeginPath(cr);
        CGRect pathRect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextAddEllipseInRect(cr, pathRect);
        CGContextClosePath(cr);
        CGContextClip(cr);
        
        CGContextDrawImage(cr, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
        
        CGImageRef clippedImage = CGBitmapContextCreateImage(cr);
        CGContextRelease(cr);
        
        UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
        CGImageRelease(clippedImage);
        
        return roundedImage;
    }
    
    return nil;
}


+ (UIImage *)circularScaleNCrop:(UIImage*)image rect:(CGRect)rect
{
    if (image) {
        // This function returns a newImage, based on image, that has been:
        // - scaled to fit in (CGRect) rect
        // - and cropped within a circle of radius: rectWidth/2
        
        //Create the bitmap graphics context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //Get the width and heights
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat rectWidth = rect.size.width;
        CGFloat rectHeight = rect.size.height;
        
        //Calculate the scale factor
        CGFloat scaleFactorX = rectWidth/imageWidth;
        CGFloat scaleFactorY = rectHeight/imageHeight;
        
        //Calculate the centre of the circle
        CGFloat imageCentreX = rectWidth/2;
        CGFloat imageCentreY = rectHeight/2;
        
        // Create and CLIP to a CIRCULAR Path
        // (This could be replaced with any closed path if you want a different shaped clip)
        CGFloat radius = rectWidth/2;
        CGContextBeginPath (context);
        CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
        CGContextClosePath (context);
        CGContextClip (context);
        
        //Set the SCALE factor for the graphics context
        //All future draw calls will be scaled by this factor
        CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
        
        // Draw the IMAGE
        CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
        [image drawInRect:myRect];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    return nil;
}



@end
