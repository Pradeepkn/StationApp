//
//  CALayer_Extension.h
//  Egmont
//
//  Created by Selvin on 2/20/14.
//  Copyright (c) 2014 Tarento India. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 * @brief Class extenstion to add additional iVars to CALayer
 * @class CALayer
 * @author Selvin
 * @version 1.0
 */
@interface CALayer () {
    // A minor catch with XCode 5 is that it doesnt let you compile if you are directly trying to access these iVars in your implementation.
    // To overcome that use KVC setValue: forKey: method ;) /Selvin
    UIColor *_topBorderColor;
    UIColor *_bottomBorderColor;
    UIColor *_leftBorderColor;
    UIColor *_rightBorderColor;
}

@end
