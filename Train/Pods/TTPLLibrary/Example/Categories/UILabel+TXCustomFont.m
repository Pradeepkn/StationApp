//
//  UILabel+TXCustomFont.m
//  TelenorX
//
//  Created by Ashish Srivastava on 23/08/13.
//  Copyright (c) 2013 Tarento. All rights reserved.
//

#import "UILabel+TXCustomFont.h"

@implementation UILabel (TXCustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
