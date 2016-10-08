//
//  ETTopAlignedLabel.m
//  Egmont
//
//  Created by Suraj Sundar on 21/07/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import "ETTopAlignedLabel.h"

@implementation ETTopAlignedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    CGFloat height = [self.text sizeWithFont:self.font
						   constrainedToSize:rect.size
							   lineBreakMode:self.lineBreakMode].height;
    if (self.numberOfLines != 0) {
        height = MIN(height, self.font.lineHeight * self.numberOfLines);
    }
    rect.size.height = MIN(rect.size.height, height);
    [super drawTextInRect:rect];
}

@end
