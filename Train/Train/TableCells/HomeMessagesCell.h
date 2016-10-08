//
//  HomeMessagesCell.h
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMessagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *messageCellContainerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDescriptionLabel;

@end
