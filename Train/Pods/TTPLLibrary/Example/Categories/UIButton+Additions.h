//
//  UIButton+Additions.h
//  Egmont
//
//  Created by Selvin on 3/19/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief To add additional customization to the UI button
 * @class UIButton+Additions
 * @author Selvin
 * @version 1.0
 */
@interface UIButton (Additions)

/**
 * @brief Set a background image for state with given color
 * @param backgroundColor The color which you want to set
 * @param state The UIControlState for which you want to set the bg color.
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state;
    
@end
