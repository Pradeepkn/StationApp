//
//  UpdateRemarksStatusApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/19/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface UpdateRemarksStatusApi : APIBase

@property (nonatomic, strong) NSString *remarksId;
@property (nonatomic, assign) NSInteger status;

@end
