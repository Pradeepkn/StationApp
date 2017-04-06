//
//  IRSDCTableViewCell.m
//  Train
//
//  Created by pradeep on 4/6/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCTableViewCell.h"

@implementation IRSDCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.streamName.layer.cornerRadius = 6.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
