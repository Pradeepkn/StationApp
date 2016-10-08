//
//  CALayer+XibConfiguration.m
//  Egmont
//
//  Created by Subramanian on 2/17/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CALayer+XibConfiguration.h"

#define kTopBorderColorKey @"_topBorderColor"
#define kBottomBorderColorKey @"_bottomBorderColor"
#define kLeftBorderColorKey @"_leftBorderColor"
#define kRightBorderColorKey @"_rightBorderColor"

@implementation CALayer (XibConfiguration)

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor {
    return self.borderUIColor;
}

- (void)setTopBorderColor:(UIColor *)topBorderColor {
    [self setValue:topBorderColor forKey:kTopBorderColorKey];
    self.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = topBorderColor.CGColor;
    sublayer.frame = CGRectMake(0, -1, self.bounds.size.width, 1);
    [self addSublayer:sublayer];
}

- (UIColor *)topBorderColor {
    return [self valueForKey:kTopBorderColorKey];
}

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor {
    
  
    
    [self setValue:bottomBorderColor forKey:kBottomBorderColorKey];
    self.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = bottomBorderColor.CGColor;
    sublayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, .7);
    
//    for (CALayer *layer in self.superlayer.sublayers)
//    {
//        NSLog(@" layer's height %f",layer.frame.size.height);
//        if (layer.frame.size.height == .7) {
//            [layer removeFromSuperlayer];
//            
//        }
//    }
   
    [self addSublayer:sublayer];
}



- (void)setBottomBorderColor:(UIColor *)bottomBorderColor withTag:(int)tag {
    
    
    
    [self setValue:bottomBorderColor forKey:kBottomBorderColorKey];
    self.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = bottomBorderColor.CGColor;
    sublayer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, .7);
    
    for (CALayer *layer in self.sublayers)
    {
       // NSLog(@" layer's height %f",layer.frame.size.height);
        if (tag == 100) {
            [layer setHidden:YES];
            
        }
    }
    
    [self addSublayer:sublayer];
}

- (UIColor *)bottomBorderColor {
    return [self valueForKey:kBottomBorderColorKey];
}

- (void)setLeftBorderColor:(UIColor *)leftBorderColor {
    [self setValue:leftBorderColor forKey:kLeftBorderColorKey];
    self.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = leftBorderColor.CGColor;
    sublayer.frame = CGRectMake(-1, 0, 1, self.bounds.size.height);
    [self addSublayer:sublayer];
}

- (UIColor *)leftBorderColor {
    return [self valueForKey:kLeftBorderColorKey];
}

- (void)setRightBorderColor:(UIColor *)rightBorderColor {
    [self setValue:rightBorderColor forKey:kRightBorderColorKey];

    self.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = rightBorderColor.CGColor;
    sublayer.frame = CGRectMake(self.bounds.size.width, 0, 1, self.bounds.size.height);
    [self addSublayer:sublayer];
}

- (UIColor *)rightBorderColor {
    return [self valueForKey:kRightBorderColorKey];
}

@end
