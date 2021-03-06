//
//  StationsListViewController.h
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stations+CoreDataClass.h"
#import "Designation+CoreDataClass.h"

@protocol StationDesignationDelegate <NSObject>

- (void)userSelectedState:(Stations *)selectedStation;
- (void)userSelectedOrganizations:(Stations *)selectedDesignation;

@end

@interface StationsListViewController : UIViewController

@property (nonatomic, assign) BOOL isStationSelected;
@property (nonatomic, assign) BOOL isFromRegistration;

@property (nonatomic, weak) id <StationDesignationDelegate> delegate;

@end
