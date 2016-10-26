//
//  StationGalleryViewCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationGalleryViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (strong, nonatomic) NSIndexPath *path;

@end
