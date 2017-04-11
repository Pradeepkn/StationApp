//
//  PSAppUtilityClass.h
//  PaySay
//
//  Created by Pradeep Narendra on 7/27/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BLMultiColorLoader;

@interface AppUtilityClass : NSObject

@property (strong, nonatomic)  BLMultiColorLoader *multiColorLoader;

+ (void)showLoaderOnView:(UIView *)view;

+ (void)hideLoaderFromView:(UIView *)view;

+ (void)storeUserName:(NSString *)userName;

+ (void)storePassword:(NSString *)password;

+ (void)storeUserEmail:(NSString *)userEmail;

+ (void)storeUserPhoneNumber:(NSString*)userPhoneNumber;

+ (NSString *)getUserName;

+ (NSString *)getUserPassword;

+ (NSString *)getUserEmail;

+ (NSString *)getUserPhoneNumber;

+ (void)showErrorMessage:(NSString *)message;

+ (BOOL)validateEmail:(NSString *)email;

+ (void)shapeTopCell:(UIView *)view withRadius:(CGFloat)radius;

+ (void)shapeBottomCell:(UIView *)view withRadius:(CGFloat)radius;

+ (CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font;

+ (NSString *)calculateSHA:(NSString *)yourString;

+ (void)storeIntValue:(NSInteger)value forKey:(NSString*)key;

+ (NSInteger)getIntValueForKey:(NSString *)key;

+ (void)storeValue:(NSString *)value forKey:(NSString*)key;

+ (NSString *)getValueForKey:(NSString *)key;

+ (NSMutableAttributedString *)updateStationAppTextForLabel:(UILabel *)label;

+ (void)addOverlayOnView:(UIView *)view;

+ (CAShapeLayer *) addDashedBorderWithColor: (CGColorRef) color ForView:(UIView*)view;

+ (void)addDottedBorderToView:(UIView*)view;

+ (void)addLineDottedBorderToView:(UIView*)view;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (NSString *)getErrorMessageFor:(NSDictionary *)errorDict;

+ (NSDate *)getDateFromMiliSeconds:(id)miliSeconds;

+ (NSString *)getHomeMessageDate:(NSDate *)date;

+ (NSString *)getWhatsNewMessageDate:(NSDate *)date;

+ (NSString *)getProfileIconNameForProfileName:(NSString *)profileName;

+ (NSMutableAttributedString *)updateBoldFontForText:(NSString *)boldText withLightFontForText:(NSString *)lightFontText;

+ (UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize;

+ (void)purgeAllModels;

+ (void)setToFirstPhaseFlow:(BOOL)selected;

+ (BOOL)isFirstPhaseSelected;

+ (void)setToEOL:(BOOL)selected;

+ (BOOL)isEOLSelected;

@end
