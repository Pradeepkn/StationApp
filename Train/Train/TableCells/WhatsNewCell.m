//
//  WhatsNewCell.m
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "WhatsNewCell.h"

@implementation WhatsNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.indicatorColor.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
