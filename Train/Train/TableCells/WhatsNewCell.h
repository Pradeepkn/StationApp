//
//  WhatsNewCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsNewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indicatorColor;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTextLabel;

@end
