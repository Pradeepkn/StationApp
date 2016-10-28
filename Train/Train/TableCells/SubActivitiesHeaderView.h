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

@property (weak, nonatomic) IBOutlet PaddedLabel *subActivityName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subActivityNameHeightConstraint;

@end
