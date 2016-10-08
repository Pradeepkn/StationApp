//
//  UIButton+TXCustomFont.m
//  TelenorX
//
//  Created by Ashish Srivastava on 23/08/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import "UIButton+TXCustomFont.h"

@implementation UIButton (TXCustomFont)

- (NSString *)fontName {
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
