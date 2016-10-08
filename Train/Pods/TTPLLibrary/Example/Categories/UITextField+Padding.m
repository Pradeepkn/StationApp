//
//  UITextField+Padding.m
//  BigRedStop
//
//  Created by Selvin on 6/16/14.
//  Copyright (c) 2014 Selvin. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)

- (void)setPadding:(NSNumber *)padding
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding.intValue, self.bounds.size.height)];
    [paddingView setBackgroundColor:[UIColor clearColor]];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (NSNumber *)padding
{
    return @(0);
}

@end
