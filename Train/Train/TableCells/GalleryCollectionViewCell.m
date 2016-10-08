//
//  GalleryCollectionViewCell.m
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

@implementation GalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.collectionImageView.alpha = 0.6f;
//    self.collectionImageView.layer.opacity = 0.9f;
    // Initialization code
    UIView *overlay = [[UIView alloc] initWithFrame:self.collectionImageView.frame];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self.collectionImageView addSubview:overlay];
}
@end
