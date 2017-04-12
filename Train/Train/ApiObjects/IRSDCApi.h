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

@end

