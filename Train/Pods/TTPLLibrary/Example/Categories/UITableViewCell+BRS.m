//
//  UITableViewCell+BRS.m
//  BigRedStop
//
//  Created by Selvin on 7/9/14.
//  Copyright (c) 2014 Selvin. All rights reserved.
//

#import "UITableViewCell+BRS.h"

@implementation UITableViewCell (BRS)

- (void)setSelectedBackgroundImage:(UIImage *)aImage {
  UIView *bgColorView = [[UIView alloc] init];
  [bgColorView setBackgroundColor:[UIColor colorWithPatternImage:aImage]];
  [self setSelectedBackgroundView:bgColorView];
}

@end
