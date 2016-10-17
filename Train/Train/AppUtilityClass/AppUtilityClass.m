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

+ (void)storePassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordKey];
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

+ (NSString *)getUserPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
}

+ (NSString *)getUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEmailKey];
}

+ (NSString *)getUserPhoneNumber {
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

+ (void)storeIntValue:(NSInteger)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

+ (NSInteger)getIntValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)storeValue:(NSString *)value forKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

+ (NSString *)getValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (NSMutableAttributedString *)updateStationAppTextForLabel:(UILabel *)label{
    NSString *completeText = @"STATION APP";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:completeText];
    NSString *boldString = @"STATION";
    NSRange boldRange = [completeText rangeOfString:boldString];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:kProximaNovaBold size:label.font.pointSize] range:boldRange];
    return attributedString;
}

+ (void)addOverlayOnView:(UIView *)view {
    UIView *overlay = [[UIView alloc] initWithFrame:view.frame];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [view addSubview:overlay];
}

+ (CAShapeLayer *) addDashedBorderWithColor: (CGColorRef) color ForView:(UIView*)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = view.frame.size;
    
    CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [shapeLayer setBounds:shapeRect];
    [shapeLayer setPosition:CGPointMake( frameSize.width/2,frameSize.height/2)];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:color];
    [shapeLayer setLineWidth:5.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
      [NSNumber numberWithInt:5],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:15.0];
    [shapeLayer setPath:path.CGPath];
    
    return shapeLayer;
}

+ (void)addDottedBorderToView:(UIView*)view {
    CAShapeLayer * dotborder = [CAShapeLayer layer];
    dotborder.strokeColor = [UIColor appImageColor].CGColor;//your own color
    dotborder.fillColor = nil;
    dotborder.lineDashPattern = @[@4, @2];//your own patten
    dotborder.cornerRadius = 3.0f;
    dotborder.lineWidth = 1.0f;
    [view.layer addSublayer:dotborder];
    dotborder.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    dotborder.frame = view.bounds;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getErrorMessageFor:(NSDictionary *)errorDict {
    NSInteger statusCode = [errorDict[@"statuscode"] integerValue];
    NSString *errorMessage;
    if (statusCode != 200) {
        errorMessage = errorDict[@"message"];
    }
    NSString *capitalisedSentence = nil;
    
    //Does the string live in memory and does it have at least one letter?
    if (errorMessage && errorMessage.length > 0) {
        // Yes, it does.
        
        capitalisedSentence = [errorMessage stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                  withString:[[errorMessage substringToIndex:1] capitalizedString]];
    } else {
        // No, it doesn't.
    }
    return capitalisedSentence;
}

@end
