//
//  NSAttributedString+StringWithImage.h
//  Voca
//
//  Created by Pradeep Narendra on 10/1/15.
//  Copyright © 2015 Zaark. All rights reserved.
//

/*!
 @discussion NSAttributedString category class to get image along with text and vice versa
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (StringWithImage)

/*!
 @abstract Get Attributed text first and image appended to string
 @discussion Method explains about NSString prefixed to UIImage.
 
 @param attributedText Text to be diplayed along with image
 @param imageName UIImage to be diplayed along with text

 @return NSMutableAttributedString which needs to be displayed on View elements

 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedName:(NSString *)attributedText withFlag:(NSString *)imageName;

/*!
 @abstract Get UIImage first and String appended to UIImage
 @discussion Method explains about image prefixed to NSString.
 
 @param attributedText Text to be diplayed along with image
 @param imageName UIImage to be diplayed along with text
 
 @return NSMutableAttributedString which needs to be displayed on View elements
 
 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedTextWithImageName:(NSString *)imageName withAttributedName:(NSString *)attributedText;

/*!
 @abstract Get Attributed text first and image appended to string
 @discussion Method explains about NSString prefixed to UIImage.
 
 @param attributedText Text to be diplayed along with image
 @param imageObject UIImage to be diplayed along with text
 
 @return NSMutableAttributedString which needs to be displayed on View elements
 
 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedName:(NSString *)attributedText withImage:(UIImage *)imageObject;

/*!
 @abstract Get UIImage first and String appended to UIImage
 @discussion Method explains about image prefixed to NSString.
 
 @param attributedText Text to be diplayed along with image
 @param imageObject UIImage to be diplayed along with text
 
 @return NSMutableAttributedString which needs to be displayed on View elements
 
 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedTextWithImage:(UIImage *)imageObject withName:(NSString *)attributedText;

/*!
 @abstract Get UIImage first and String appended to UIImage
 @discussion Method explains about image prefixed to NSString.
 
 @param attributedText Text to be diplayed along with image
 @param imageObject UIImage to be diplayed along with text
 
 @return NSMutableAttributedString which needs to be displayed on View elements
 
 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedTextWithLeftImage:(UIImage *)imageObject withName:(NSString *)attributedText;

/*!
 @abstract Get UIImage first and String appended to UIImage
 @discussion Method explains about image prefixed to NSString.
 
 @param attributedText Text to be diplayed along with image
 @param imageObject UIImage to be diplayed along with text
 
 @return NSMutableAttributedString which needs to be displayed on View elements
 
 @since 1.0
 */
+ (NSMutableAttributedString *)getAttributedTextWithRightImage:(UIImage *)imageObject withName:(NSString *)attributedText;

+ (NSMutableAttributedString *)getBalanceTextWithImage:(UIImage *)imageObject withName:(NSString *)attributedText;

+ (NSMutableAttributedString *)getPaySayTextWithLeftImage:(UIImage *)imageObject withName:(NSString *)attributedText;

@end
