//
//  IRSDCApi.h
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface IRSDCApi : APIBase

@end

@interface IRSDCStationsDashboard : IRSDCApi

@end

@interface IRSDCGetStationTasks : IRSDCApi

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, assign) NSInteger percentageCompleted;

@end

@interface IRSDCGetStationSubTasks : IRSDCApi

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, assign) BOOL editStatus;
@property (nonatomic, strong) NSString *activityName;

@end

