//
//  IRSDCStatusViewController.h
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

@interface IRSDCStatusViewController : UIViewController

@property (nonatomic, strong) Tasks *selectedTasks;
@property (nonatomic, strong) SubTasks *selectedSubTasks;
@property (nonatomic, strong) Stations *selectedStations;
@property (nonatomic, assign) BOOL isEditable;

@end
