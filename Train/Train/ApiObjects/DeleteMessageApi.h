//
//  DeleteMessageApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/26/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface DeleteMessageApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, assign) BOOL isInfoMessage;

@end
