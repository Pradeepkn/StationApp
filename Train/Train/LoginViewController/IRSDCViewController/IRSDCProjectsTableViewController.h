//
//  IRSDCProjectsTableViewController.h
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stations+CoreDataClass.h"

@protocol StationProjectsDelegate <NSObject>

- (void)userSelectedIRSDCProjects:(Stations *)selectedStation;

@end

@interface IRSDCProjectsTableViewController : UITableViewController

@property (nonatomic, weak) id <StationProjectsDelegate> delegate;

@end
