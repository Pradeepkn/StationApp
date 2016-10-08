//
//  NSAttributedString+StringWithImage.m
//  Voca
//
//  Created by Pradeep Narendra on 10/1/15.
//  Copyright © 2015 Zaark. All rights reserved.
//

#import "NSAttributedString+StringWithImage.h"

static NSInteger kGapBetweenImageAndText = 10.0f;

@implementation NSAttributedString (StringWithImage)

+ (NSMutableAttributedString *)getAttributedName:(NSString *)attributedText withFlag:(NSString *)imageName {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(+kGapBetweenImageAndText, -2, attachment.image.size.width - 2, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:attributedText];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:attachmentString]];
    return myString;
}

+ (NSMutableAttributedString *)getAttributedTextWithImageName:(NSString *)imageName withAttributedName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(-kGapBetweenImageAndText, -2, attachment.image.size.width - 2, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:attributedText]];
    return myString;
}

+ (NSMutableAttributedString *)getAttributedName:(NSString *)attributedText withImage:(UIImage *)imageObject {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(+kGapBetweenImageAndText, -2, attachment.image.size.width - 2, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:attributedText];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:attachmentString]];
    return myString;
}

+ (NSMutableAttributedString *)getAttributedTextWithImage:(UIImage *)imageObject withName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(-kGapBetweenImageAndText, -2, attachment.image.size.width - 2, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:attributedText]];
    return myString;
}

+ (NSMutableAttributedString *)getAttributedTextWithLeftImage:(UIImage *)imageObject withName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(0, -1, attachment.image.size.width, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:attributedText]];
    return myString;
}

+ (NSMutableAttributedString *)getAttributedTextWithRightImage:(UIImage *)imageObject withName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(0, -attachment.image.size.width / 3, attachment.image.size.width, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:attributedText];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithAttributedString:attachmentString]];
    return myString;
}

+ (NSMutableAttributedString *)getBalanceTextWithImage:(UIImage *)imageObject withName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(0, 0, attachment.image.size.width + 5, attachment.image.size.height + 5);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",attributedText]]];
    return myString;
}

+ (NSMutableAttributedString *)getPaySayTextWithLeftImage:(UIImage *)imageObject withName:(NSString *)attributedText {
    [NSAttributedString resetGapForText:attributedText];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image =  imageObject;
    attachment.bounds = CGRectMake(-kGapBetweenImageAndText, -kGapBetweenImageAndText/1.5, 40, 40);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:attributedText]];
    return myString;
}

+ (void)resetGapForText:(NSString *)text {
    if (text.length <= 0) {
        kGapBetweenImageAndText = 0.0f;
    }else{
        kGapBetweenImageAndText = 10.0f;
    }
}

@end
