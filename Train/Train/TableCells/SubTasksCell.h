//
//  SubTasksCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTasksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *remarksHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarksHeaderHeightConstraint;

@end
