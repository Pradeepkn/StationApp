//
//  UpdateSubTasksStatusApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface UpdateSubTasksStatusApi : APIBase

@property (nonatomic, strong) NSString *stationSubActivityId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *remarks;

@end
