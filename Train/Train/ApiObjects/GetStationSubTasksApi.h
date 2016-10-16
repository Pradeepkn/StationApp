//
//  GetStationSubTasksApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface GetStationSubTasksApi : APIBase

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *taskId;

@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, assign) BOOL editStatus;

@property (nonatomic, strong) NSMutableArray *subActivitiesArray;
@property (nonatomic, strong) NSMutableArray *remarksArray;

@end
