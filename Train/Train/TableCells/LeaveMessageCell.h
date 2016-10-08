//
//  LeaveMessageCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectStationButton;
@property (weak, nonatomic) IBOutlet UIView *leaveMessageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userThumbnailImageView;
@property (weak, nonatomic) IBOutlet UITextField *leaveMessageTextField;
@property (weak, nonatomic) IBOutlet UITextView *leaveMessageTextView;

@end
