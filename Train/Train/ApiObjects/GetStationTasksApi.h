//
//  GetStationTasksApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface GetStationTasksApi : APIBase

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, assign) NSInteger percentageCompleted;

@end
