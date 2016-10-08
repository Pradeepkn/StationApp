//
//  NSString+Validation.h
//  PICentrix
//
//  Created by Subramanian on 12/8/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhoneNumberValidation) {
  NSCPhoneNumberEmpty = 0,
  NSCPhoneNumberLengthLow,
  NSCPhoneNumberLengthHigh,
  NSCPhoneNumberInvalid,
  NSCPSuccess
};

/*!
 @discussion NSString class related validation methods.

 ## Version information

 __Version__: 1.0

 __Found__: 12/8/14

 __Last update__: 12/8/14

 __Developer__: Subramanian, Tarento Technologies Pvt Ltd.

 */
@interface NSString (Validation)

/*
 @abstract Returns TRUE / FALSE based on the given email string is valid or not.

 @discussion It will check the email is valid or not. If it is valid then it
 will return true else false.

 @return Returns TRUE/FALSE

 @since 1.0+
 */

- (BOOL)isValidEmail;

/*
 @abstract Returns TRUE / FALSE based on the given name string is valid or not.

 @discussion It will check the name length is valid or not. If it is valid then
 it
 will return true else false.

 @return Returns TRUE/FALSE

 @since 1.0+
 */

- (BOOL)isValidName;

/*
 @abstract Returns TRUE / FALSE based on the given mobile number string is valid
 or not.

 @discussion It will check the mobile lenght is greater than 8 and lessthan 11.
 If it is valid then
 it
 will return true else false.

 @return Returns TRUE/FALSE

 @since 1.0+
 */

- (PhoneNumberValidation)isValidMobileNumber;

@end
