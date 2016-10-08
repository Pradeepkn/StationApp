//
//  UITextField+PaddingText.h
//  PaySay
//
//  Created by Pradeep Narendra on 6/6/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PaddingText)

-(void) setLeftPadding:(int) paddingValue;

-(void) setRightPadding:(int) paddingValue;

-(void) setTextFieldPadding:(int)paddingValue;

@end
