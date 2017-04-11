//
//  SubActivitiesHeaderView.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaddedLabel.h"

@interface SubActivitiesHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mileStoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusInfoSymbol;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
