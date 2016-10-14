//
//  ForgotpasswordAuthKeyApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/14/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface ForgotpasswordAuthKeyApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *authKey;

@end
