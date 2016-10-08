//
//  OverallStatusCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverallStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *overallStatusHeaderLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *statusProgressView;
@property (weak, nonatomic) IBOutlet UILabel *statusProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusInfoSymbol;

@end
