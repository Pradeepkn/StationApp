//
//  VykeAlertModel.h
//  Voca
//
//  Created by Pradeep Narendra on 10/5/15.
//  Copyright © 2015 Zaark. All rights reserved.
//

/*!
 @discussion Custom Alert model class. Using this class we can set Alert properties like
 Alert background color, Title, Message, Buttons color, text etc.,
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

// Enum to identify or selection of Different Alert types
typedef NS_ENUM(NSInteger, VKAlertType) {
    kVKSuggestion = 0,
    kVKInfoType,
    kVKConfirmationType,
    kVKButtonType
};

// Enum to identify button action type
typedef NS_ENUM(NSInteger, VKAlertButtonType) {
    kVKPrimaryButton = 0,
    kVKSecondaryButton
};

@interface CustomAlertModel : NSObject

@property (nonatomic, assign) VKAlertType alertType;

// Alert button array. Based on it user can draw multiple number of buttons. Now limited to 2.
@property (nonatomic, strong) NSMutableArray *buttonsArray;

// NSString alertTitle
@property (nonatomic, strong) NSString *alertTitle;
// NSString alertMessageBody
@property (nonatomic, strong) NSString *alertMessageBody;
// Alert view background color
@property (nonatomic, strong) UIColor *overLayColor;

// Alert view subvies color properties
// Left button color
@property (nonatomic, strong) UIColor *primaryButtonColor;
// Right button color
@property (nonatomic, strong) UIColor *secondaryButtonColor;
// Alert view background color
@property (nonatomic, strong) UIColor *backGroundColor;
// Alert view title label color
@property (nonatomic, strong) UIColor *alertTitleColor;
// Alert view message label color
@property (nonatomic, strong) UIColor *alertMessageColor;
// Alert view left button title color
@property (nonatomic, strong) UIColor *primaryButtonTitleColor;
// ALert view right button title color
@property (nonatomic, strong) UIColor *secondaryButtonTitleColor;

// Alert view button, text font properties
@property (nonatomic, strong) UIFont *alertTitleFont;
@property (nonatomic, strong) UIFont *alertMessageFont;
@property (nonatomic, strong) UIFont *alertPrimaryButtonFont;
@property (nonatomic, strong) UIFont *alertSecondaryButtonFont;

// Alert view with table view as subview.

// Alertview model object
@property (nonatomic, strong) UITableView *alertTableView;
// Table Alert view table entries data source
@property (nonatomic, strong) NSMutableArray *alertTableEntries;
// Table alert view images entries data source
@property (nonatomic, strong) NSMutableArray *alertTableImages;
// Table alert view previous selected indexes if we need to display previous selected records
@property (nonatomic, strong) NSMutableArray *selectedIndexes;

// Table Alert view color objects to set required table alert view elements colors
@property (nonatomic, strong) UIColor *alertTableBackGroundColor;
@property (nonatomic, strong) UIColor *alertCellBackGroundColor;
@property (nonatomic, strong) UIColor *alertCellTitleColor;
@property (nonatomic, strong) UIColor *alertTableSeparatorColor;
@property (nonatomic, strong) UIColor *alertTableCellSelectedColor;
@property (nonatomic, strong) UIColor *alertCellHighlightedTitleColor;

// Table alert view title label font
@property (nonatomic, strong) UIFont *alertCellTitleLabelFont;

// Alert table view cell image on left hand side.
@property (nonatomic, strong) UIImage *alertCellImage;
// Alert table view cell background image
@property (nonatomic, strong) UIImage *alertCellBackgroundImage;
// Alert table view cell accessory image view. Right now only ticker image has been used.
@property (nonatomic, strong) UIImage *alertCellAccesoryImage;
// Table alert view flag to enable and disable scroll
@property (nonatomic, assign) BOOL isTableViewScrollEnabled;

// Alert view width offset to set disirable alert view width
@property (nonatomic, assign) NSInteger kAlertViewWidthOffSet;
// Alert view margin from left and right side.
@property (nonatomic, assign) NSInteger kAlertMarginOffSet;
// Alert view gap between "Title" and "Message"
@property (nonatomic, assign) NSInteger kAlertTitleToMessageGapOffSet;
// Alert view virticle (Y) offset to position alert view on super view.
@property (nonatomic, assign) NSInteger kAlertYOffSet;
// Alert view horizontal (X) offset to position alert view on super view.
@property (nonatomic, assign) NSInteger kAlertXOffSet;
// Alert view "Title" lable height.
@property (nonatomic, assign) NSInteger kAlertTitleHeightOffSet;
// Alert view bottom "Buttons" container view Height offset.
@property (nonatomic, assign) NSInteger kAlertBottomButtonContainerOffSet;

@property (nonatomic, assign) NSInteger kAlertWidthOffSet;
// Table Alert view cell height
@property (nonatomic, assign) NSInteger kAlertTableCellHeight;
// Alert view center (X) position
@property (nonatomic, assign) NSInteger kAlertCenterXOffSet;
// Alert view center (Y) position
@property (nonatomic, assign) NSInteger kAlertCenterYOffSet;

// Table alert view previous selected index.
@property (nonatomic, assign) NSInteger kAlertPreviousSelectedIndex;

// Flag to enable and disable Table alert view previous selected index.
@property (nonatomic, assign) BOOL shouldDisplayPreviousSelectedIndex;

@end
