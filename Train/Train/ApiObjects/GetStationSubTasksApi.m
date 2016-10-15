//
//  GetStationSubTasksApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GetStationSubTasksApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation GetStationSubTasksApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/getStationSubTasks",[super baseURL]];
}

- (NSMutableDictionary *)requestParameters{
    return nil;
}

- (NSString *)requestType{
    return APIGet;
}

- (NSString *)apiAuthenticationAccessToken{
    return nil;
}

- (NSDictionary *)customHTTPHeaders {
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.taskId], @"application/json",self.email, self.taskId, self.stationId] forKeys:@[@"Checksum", @"Content-Type", kEmailKey, kTaskIdKey, kStationIdKey]];
    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    self.activityName = apiDataSource[@"activityName"];
    self.editStatus = [apiDataSource[@"editStatus"] boolValue];
    if ([apiDataSource[@"subActivities"] isKindOfClass:[NSArray class]]) {
        NSArray *subTasksDataSource = apiDataSource[@"subActivities"];
        [[CoreDataManager sharedManager] saveSubTasks:subTasksDataSource];
    }
}

@end
