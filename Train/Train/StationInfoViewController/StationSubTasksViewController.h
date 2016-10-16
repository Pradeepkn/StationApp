//
//  StationSubTasksViewController.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

@interface StationSubTasksViewController : UIViewController

@property (strong, nonatomic) Stations *selectedStation;
@property (nonatomic, strong) Tasks *selectedTask;

@end
