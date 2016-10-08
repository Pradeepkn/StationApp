//
//  CALayer+XibConfiguration.h
//  Egmont
//
//  Created by Subramanian on 2/17/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer_Extension.h"
#import <UIKit/UIKit.h>

/**
 * @brief Category that handles additional configurable functionalities
 * via XIB
 * @class CALayer (XibConfiguration)
 * @author Subramanian
 * @version 1.0
 */
@interface CALayer (XibConfiguration)

///to set the entire border color for all 4 sides
@property (nonatomic, assign) UIColor *borderUIColor;
///to set the border color for top side alone
@property (nonatomic, assign) UIColor *topBorderColor;
///to set the border color for bottom side alone
@property (nonatomic, assign) UIColor *bottomBorderColor;
///to set the border color for left side alone
@property (nonatomic, assign) UIColor *leftBorderColor;
///to set the border color for right side alone
@property (nonatomic, assign) UIColor *rightBorderColor;

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor withTag:(int)tag;
@end
