//
//  TasksHeaderView.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *overallStatusHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
