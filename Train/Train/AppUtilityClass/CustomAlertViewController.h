//
//  VykeAlertViewController.h
//  Voca
//
//  Created by Pradeep Narendra on 10/5/15.
//  Copyright © 2015 Zaark. All rights reserved.
//

/*!
 @discussion Custom Alert view class. Using this class user can draw custom alert view with easy call back mechanism.
 With the help of Alert model class user can customise Alertview properties.
 */
#import <UIKit/UIKit.h>
#import "CustomAlertModel.h"

typedef void(^AlertButtonAction)(id sender);
typedef void(^AlertTableCellSelectionAction)(id sender);

@interface CustomAlertViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

// Alertview model object
@property (nonatomic, strong) CustomAlertModel *alertModel;

// Alertview button action call back representation object
@property (nonatomic, strong) AlertButtonAction callBackObject;

// Alertview table cell section action call back representation object
@property (nonatomic, strong) AlertTableCellSelectionAction cellSelectionCallBack;

// Shared instance of Custom alert view to ease developer work.
+ (CustomAlertViewController *)sharedInstance;

/*!
 @abstract displayAlertViewOnView upon given view property with call back option
 @discussion With this method user can display alertview on given baseview 
             and can get alertview button action as call back.
 
 @param baseView Container view on which alert view should be expected to display.
 @param alertModel AlertModel with user defined view properties.
 @param onButtonClick Call back object which is used to assign 
        callBackObject on Custom alert button click

 @warning Make sure to set all relavent or neded Alertmodel properties to get desired UI output.

 @since 1.0
 */
- (void)displayAlertViewOnView:(UIView *)baseView
                     withModel:(CustomAlertModel *)alertModel
                   andCallBack:(AlertButtonAction)onButtonClick;

/*!
 @abstract showAlertTableViewOn upon given view property with call back option
 @discussion With this method user can display alertview on given baseview
 and can get alertview button action as call back.
 
 @param containerView Container view on which alert view should be expected to display.
 @param alertModel AlertModel with user defined view properties.
 @param onCompletion Call back object which is used to assign
 callBackObject on Custom table alert cell action click
 
 @warning Make sure to set all relavent or neded Alertmodel properties to get desired UI output.
 
 @since 1.0
 */
- (void) showAlertTableViewOn:(UIView *)containerView
                    withModel:(CustomAlertModel *)alertModel
                 onCompletion:(AlertTableCellSelectionAction)onCompletion;

- (void)removeAlertView;

@end
