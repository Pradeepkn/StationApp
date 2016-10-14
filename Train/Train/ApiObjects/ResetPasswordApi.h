//
//  ResetPasswordApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/14/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface ResetPasswordApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *authKey;
@property (nonatomic, strong) NSString *password;

@end
