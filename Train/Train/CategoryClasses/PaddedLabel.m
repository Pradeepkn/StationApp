//
//  PaddedLabel.m
//  Train
//
//  Created by pradeep on 28/10/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "PaddedLabel.h"

@implementation PaddedLabel


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if(self){
        self.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}


@end
