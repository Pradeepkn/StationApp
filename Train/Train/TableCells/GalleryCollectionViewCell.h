//
//  GalleryCollectionViewCell.h
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageDescription;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end
