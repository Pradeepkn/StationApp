//
//  NSString+Validation.m
//  PICentrix
//
//  Created by Subramanian on 12/8/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import "NSString+Validation.h"

static const int PhoneNumberMinimumLength = 8;
static const int PhoneNumberMaximumLength = 11;

@implementation NSString (Validation)

#pragma mark - Email validation.
- (BOOL)isValidEmail {

  NSString *emailString =
      [self stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  BOOL isValid = YES;
  BOOL sticterFilter = YES; // Discussion
  // http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/

  NSString *stricterFilterString =
      @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest =
      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  if (![emailTest evaluateWithObject:emailString]) {
    isValid = NO;
  }
  return isValid;
}

- (BOOL)isValidName {
  BOOL isValid = YES;
  NSString *nameString =
      [self stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (!nameString.length) {
    isValid = NO;
  }
  return isValid;
}

- (PhoneNumberValidation)isValidMobileNumber {
  NSString *mobileNumber = self;
  PhoneNumberValidation validation;
  if (!mobileNumber.length) {
    validation = NSCPhoneNumberEmpty;
  } else if (mobileNumber.length < PhoneNumberMinimumLength) {
    validation = NSCPhoneNumberLengthLow;
  } else if (mobileNumber.length > PhoneNumberMaximumLength) {
    validation = NSCPhoneNumberLengthHigh;
  } else {
    validation = NSCPSuccess;
  }
  return validation;
}

@end
