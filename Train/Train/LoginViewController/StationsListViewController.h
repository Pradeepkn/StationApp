//
//  StationsListViewController.h
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StationDesignationDelegate <NSObject>

- (void)userSelectedEntry:(NSString*)selectedEntry isStation:(BOOL)isStation;

@end

@interface StationsListViewController : UIViewController

@property (nonatomic, assign) BOOL isStationSelected;

@property (nonatomic, weak) id <StationDesignationDelegate> delegate;

@end
