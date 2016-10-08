//
//  UIImageView+TTPLImageViewUtilities.m
//  TelenorX
//
//  Created by Pradi.K.N on 8/13/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import "UIImageView+TTPLImageViewUtilities.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (TTPLImageViewUtilities)

+(UIImageView *)getCircularImageView:(UIImageView *)imageView{
    //We are changing the image once we get it from the API.
    //makeRoundCornersWithRadius:radius() method will make the image as rounded one.
    //Not required to changed the imageview.
    return imageView;
    [imageView setBackgroundColor:[UIColor clearColor]];
    imageView.layer.cornerRadius = (imageView.frame.size.height / 2);
    [imageView.layer setMasksToBounds:YES];
    return imageView;
}

@end
