//
//  UITextField+PlaceholderColor.m
//  BigRedStop
//
//  Created by Selvin on 6/16/14.
//  Copyright (c) 2014 Selvin. All rights reserved.
//

#import "UITextField+PlaceholderColor.h"

@implementation UITextField (PlaceholderColor)

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

- (UIColor*)placeHolderColor
{
    return [UIColor whiteColor];
}

@end
