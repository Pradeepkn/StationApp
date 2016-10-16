//
//  UIColor+AppColor.m
//  PaySay
//
//  Created by Pradeep Narendra on 6/6/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "AppConstants.h"

@implementation UIColor (AppColor)

+ (UIColor *)appBlueColor {
    return RGBACOLOR(75, 185, 221, 1.0); // #4BB9DD
}

+ (UIColor *)appGreyColor {
    return RGBACOLOR(53, 51, 63, 1.0);
}

+ (UIColor *)darkBodyColor {
    return RGBACOLOR(56, 56, 69, 1.0); // #383845
}

+ (UIColor *)midGrayColor {
    return RGBACOLOR(216, 214, 214, 1.0); //#D8D6D6
}

+ (UIColor *)backgroundGrayColor {
    return RGBACOLOR(247, 247, 247, 1.0); //#F7F7F7
}

+ (UIColor *)appRedColor {
    return RGBACOLOR(234, 81, 81, 1.0); //#F15300
}

+ (UIColor *)appGreenColor {
    return RGBACOLOR(149, 215, 109, 1.0); //#5DDB5B
}

+ (UIColor *)appYellowColor {
    return RGBACOLOR(243, 210, 21, 1.0); //#F3D215
}

+ (UIColor *)appPrimaryBlueColorButton {
    return RGBACOLOR(47, 172, 213, 1.0); //#2FACD5
}

+ (UIColor *)appdarkColorButtons {
    return RGBACOLOR(36, 36, 45, 1.0); //#24242D
}

+ (UIColor *)appTextColor {
    return RGBACOLOR(110, 93, 93, 1.0);
}

+ (UIColor *)appImageColor {
    return RGBACOLOR(110, 93, 93, 1.0);
}

@end
