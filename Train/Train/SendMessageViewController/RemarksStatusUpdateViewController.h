//
//  RemarksStatusUpdateViewController.h
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"
#import "CoreDataManager.h"

@protocol RemarksStatusDelegate <NSObject>

- (void)updateRemarks:(NSString *)remarksMessage;
- (void)updateStatus:(TasksStatus)status;

@end

@interface RemarksStatusUpdateViewController : UIViewController

@property (nonatomic, weak) id <RemarksStatusDelegate> delegate;
@property (nonatomic, assign) BOOL isRemarksUpdate;
@property (strong, nonatomic) Stations *selectedStation;
@property (nonatomic, assign) NSInteger statusCode;

@end
