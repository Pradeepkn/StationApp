//
//  LoginApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface LoginApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

@end
