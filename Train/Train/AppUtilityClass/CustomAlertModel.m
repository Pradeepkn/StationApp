//
//  VykeAlertModel.m
//  Voca
//
//  Created by Pradeep Narendra on 10/5/15.
//  Copyright © 2015 Zaark. All rights reserved.
//

#import "CustomAlertModel.h"
#import "UIColor+AppColor.h"

#define Localize(x) [[NSBundle mainBundle] localizedStringForKey:x value:nil table:@"Localizable"]

@implementation CustomAlertModel

- (id)init {
    self = [super init];
    if (self) {
        self.alertTitle = @"";
        self.alertMessageBody = @"";
        self.buttonsArray = [[NSMutableArray alloc] initWithObjects:Localize(@"Cancel"), Localize(@"OK"), nil];
        self.selectedIndexes = [[NSMutableArray alloc] init];
        self.alertType = kVKConfirmationType;
        self.primaryButtonColor = [UIColor grayColor];
        self.secondaryButtonColor = [UIColor appBlueColor];
        self.primaryButtonTitleColor = [UIColor whiteColor];
        self.secondaryButtonTitleColor = [UIColor whiteColor];
        self.backGroundColor = [UIColor whiteColor];
        self.alertTitleColor = [UIColor blackColor];
        self.alertMessageColor = [UIColor blackColor];
        self.alertTitleFont = [UIFont systemFontOfSize:18];
        self.alertMessageFont = [UIFont systemFontOfSize:14];
        self.alertPrimaryButtonFont = [UIFont systemFontOfSize:14];
        self.alertSecondaryButtonFont = [UIFont systemFontOfSize:14];
        self.alertTableEntries = [[NSMutableArray alloc] init];
        self.alertTableImages = [[NSMutableArray alloc] init];
        self.alertTableBackGroundColor = [UIColor whiteColor];
        self.alertCellBackGroundColor = [UIColor whiteColor];
        self.alertCellTitleColor = [UIColor blackColor];
        self.alertTableSeparatorColor = [UIColor lightGrayColor];
        self.alertTableCellSelectedColor = [UIColor lightGrayColor];
        self.alertCellHighlightedTitleColor = [UIColor grayColor];
        self.alertCellTitleLabelFont = [UIFont systemFontOfSize:14];
        
        self.alertCellImage = nil;
        self.alertCellBackgroundImage = nil;
        self.alertCellAccesoryImage = nil;
        self.isTableViewScrollEnabled = NO;
        self.overLayColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        
        self.kAlertViewWidthOffSet = 280.0f;
        self.kAlertYOffSet        = 10.0f;
        self.kAlertXOffSet        = 20.0f;
        self.kAlertTitleHeightOffSet = 30.0f;
        self.kAlertBottomButtonContainerOffSet = 40.0f;
        self.kAlertTableCellHeight = 45.0f;
        self.kAlertTitleToMessageGapOffSet = 10.0f;
        self.kAlertCenterXOffSet = 0.0f;
        self.kAlertCenterYOffSet = 0.0f;
        self.kAlertPreviousSelectedIndex = -1.0f;
        self.shouldDisplayPreviousSelectedIndex = NO;
        self.kAlertWidthOffSet = 40.0f;
        self.kAlertMarginOffSet = 15.0f;
    }
    return self;
}

@end
