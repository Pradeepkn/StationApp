//
//  SignUpEntryCell.h
//  Train
//
//  Created by Pradeep Narendra on 10/9/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *entryTextField;
@property (weak, nonatomic) IBOutlet UIButton *placeHolderButton;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@end
