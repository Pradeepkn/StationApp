//
//  RightAlignImageButton.m
//  Train
//
//  Created by pradeep on 4/5/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "RightAlignImageButton.h"

@implementation RightAlignImageButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.imageEdgeInsets = UIEdgeInsetsMake(0., self.frame.size.width - (self.imageView.image.size.width + 15.), 0., 0.);
}

@end
