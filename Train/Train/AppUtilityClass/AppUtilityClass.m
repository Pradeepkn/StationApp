//
//  PSAppUtilityClass.m
//  PaySay
//
//  Created by Pradeep Narendra on 7/27/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "AppUtilityClass.h"
#import "BLMultiColorLoader.h"
#import "AppConstants.h"
#import "CustomAlertViewController.h"
#import "UIColor+AppColor.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AppUtilityClass

#pragma mark -
#pragma mark - PSAppUtilityClass Shared Instance
+ (instancetype)sharedInstance {
    static AppUtilityClass *appUtilitySharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appUtilitySharedInstance = [[super alloc] initUniqueInstance];
        /// Please reset the flag here is you are not using JSON Request
        /// Serializer
        appUtilitySharedInstance.multiColorLoader = [[BLMultiColorLoader alloc] initWithFrame:CGRectMake(0,0,30,30)];
        // Customize the line width
        appUtilitySharedInstance.multiColorLoader.lineWidth = 2.0;
        
        // Pass the custom colors array
        appUtilitySharedInstance.multiColorLoader.colorArray = [NSArray arrayWithObjects:[UIColor redColor],
                                       [UIColor purpleColor],
                                       [UIColor orangeColor],
                                       [UIColor blueColor], nil];
        [appUtilitySharedInstance.multiColorLoader setHidden:YES];
    });
    return appUtilitySharedInstance;
}

- (instancetype)initUniqueInstance {
    return [super init];
}

+ (void)showLoaderOnView:(UIView *)view {
    [view addSubview:[AppUtilityClass sharedInstance].multiColorLoader];
    [AppUtilityClass sharedInstance].multiColorLoader.center = view.center;
    [[AppUtilityClass sharedInstance].multiColorLoader startAnimation];
    [[AppUtilityClass sharedInstance].multiColorLoader setHidden:NO];
}

+ (void)hideLoaderFromView:(UIView *)view {
    [[AppUtilityClass sharedInstance].multiColorLoader stopAnimationAfter:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AppUtilityClass sharedInstance].multiColorLoader setHidden:YES];
        [view willRemoveSubview:[AppUtilityClass sharedInstance].multiColorLoader];
    });
}

+ (void)storeUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUsernameKey];
}

+ (void)storeUserEmail:(NSString *)userEmail {
    [[NSUserDefaults standardUserDefaults] setObject:userEmail forKey:kEmailKey];
}

+ (void)storeUserPhoneNumber:(NSString*)userPhoneNumber {
    [[NSUserDefaults standardUserDefaults] setObject:userPhoneNumber forKey:kPhoneNumberKey];
}

+ (NSString *)getUserName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUsernameKey];
}

+ (NSString *)getUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEmailKey];
}

+ (NSString *)getUserPhoneNUmber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPhoneNumberKey];
}

+ (void)showErrorMessage:(NSString *)message {
    CustomAlertModel *alertModel = [[CustomAlertModel alloc] init];
    alertModel.secondaryButtonColor = [UIColor appRedColor];
    alertModel.kAlertMarginOffSet = 20.0f;
    alertModel.alertMessageBody = message;
    alertModel.buttonsArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Ok", nil), nil];
    [[CustomAlertViewController sharedInstance] displayAlertViewOnView:[[UIApplication sharedApplication] keyWindow] withModel:alertModel andCallBack:^(UIButton *sender) {
    }];
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];    //  return 0;
    return [emailTest evaluateWithObject:email];
}

+ (void)shapeTopCell:(UIView *)view withRadius:(CGFloat)radius{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft) cornerRadii:CGSizeMake(radius, radius)];
    layer.path = shadowPath.CGPath;
    view.layer.mask = layer;
}

+ (void)shapeBottomCell:(UIView *)view  withRadius:(CGFloat)radius{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(radius, radius)];
    layer.path = shadowPath.CGPath;
    view.layer.mask = layer;
}

+ (CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGRect rect = [textToMesure boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil];
    rect.size.width = ceil(rect.size.width);
    rect.size.height = ceil(rect.size.height);
    
    return rect.size;
}

+ (NSString *)calculateSHA:(NSString *)yourString
{
    const char *ptr = [yourString UTF8String];
    
    int i =0;
    int len = (int)strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

@end
