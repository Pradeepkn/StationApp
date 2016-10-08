//
//  StationsStatusCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationsStatusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *stationStatusContainerView;
@property (weak, nonatomic) IBOutlet UILabel *statusColor;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end
