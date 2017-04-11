//
//  AppConstants.h
//  PaySay
//
//  Created by Pradeep Narendra on 6/5/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h

// Enum to identify Status
typedef NS_ENUM(NSInteger, DashboardStatus) {
    kNotCompleted = 1,
    kCompleted
};

// Enum to identify Tasks Status
typedef NS_ENUM(NSInteger, TasksStatus) {
    kTaskToStart = 1,
    kTaskOnTrack,
    kTaskDelayed,
    kTaskCompleted
};

/******** access token key *********/
#define ACCESS_TOKEN @"accessToken"

#define kDeviceToken @"kDevicePushToken"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define OS_VERSION_EQUALS_OR_AFTER(version) [[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."][0] intValue] >= version

#define OS_VERSION_BEFORE(version) [[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."][0] intValue] < version

#define CLIENT_KEY @"CRDNwxmwHj688CuVjLEcq7ZudupVUIbke2Jflda7"
#define CLIENT_SECRET @"rbkopL6SLTPbmoEAViDglnwPQdVv4aC62UC6vxC16PiA4HIT5wY9nfgttRSiZgVEOZY7zfxfUk1tLNATq3i9Itbmuwb7sHK8gBC5epLxNqCIju6zYE6eS4MEFAbCZGjc"

static NSString *const kUsernameKey = @"username";
static NSString *const kGrantTypeKey = @"grant_type";
static NSString *const kClientIdKey = @"client_id";
static NSString *const kClientSecretKey = @"client_secret";


static NSString *const kEmailKey = @"email";
static NSString *const kPasswordKey = @"password";
static NSString *const kStationName = @"stationName";
static NSString *const kDesignation = @"designation";
static NSString *const kFirstName = @"firstName";
static NSString *const kLastName = @"lastName";

static NSString *const kAuthKey = @"authKey";
static NSString *const kMessageKey = @"message";
static NSString *const kMessageIDKey = @"messageId";
static NSString *const kStationIdKey = @"stationId";
static NSString *const kTaskIdKey = @"taskId";

static NSString *const kStationSubActivityIdKey = @"stationSubActivityId";
static NSString *const kStationRemarksIdKey = @"remarksId";
static NSString *const kStatusKey = @"status";

static NSString *const kImagesKey = @"images";
static NSString *const kRemarks = @"remarks";
static NSString *const kNameKey = @"name";
static NSString *const kPhoneNumberKey = @"phone_number";

static NSString *const kRegistraionId = @"registration_id";

static NSString *const kOtp = @"otp";

static NSString *const kAmountKey = @"amount";
static NSString *const kBillNumberKey = @"bill_number";
static NSString *const kBasketKey = @"basket";
static NSString *const kUseRewardsKey = @"use_rewards";

static NSString *const kService = @"service";
static NSString *const kRechargeNumber = @"recharge_number";
static NSString *const kOperatorCode = @"operator_code";

static NSInteger kBubbleRadius  = 6.f;

static NSInteger kTableCellHeight = 48.0f;

static NSInteger kTableSectionCellHeight = 50.0f;

// User defaults keys
static NSString *const kSelectedStationIndex = @"SelectedStationIndex";
static NSString *const kSelectedDesignationIndex = @"SelectedDesignationIndex";
static NSString *const kRemeberMeKey = @"RememberMeKey";

// Proxima nova bold
static NSString *const kProximaNovaSemibold = @"ProximaNova-Semibold";
static NSString *const kProximaNovaBold = @"ProximaNova-Bold";
static NSString *const kProximaNovaLight = @"ProximaNova-Light";
static NSString *const kProximaNovaRegular = @"ProximaNova-Regular";

#endif /* AppConstants_h */
