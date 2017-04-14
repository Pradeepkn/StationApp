//
//  IRSDCApi.m
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation IRSDCApi

-(instancetype)init{
    if(self = [super init]){
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return nil;
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
    return nil;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
}

@end

@implementation IRSDCStationsDashboard

- (NSString *)urlForAPIRequest{
    [super urlForAPIRequest];
    return [NSString stringWithFormat:@"%@/IRSDCStationDashboard",[super baseURL]];
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    [super parseAPIResponse:responseDictionary];
    NSArray *apiDataSource = responseDictionary[@"data"];
    for (NSDictionary *apiDataDict in apiDataSource) {
        NSArray *stationsDataSource = apiDataDict[@"stations"];
        [[CoreDataManager sharedManager] saveStations:stationsDataSource forPhase:kIRSDCType];
    }
}

- (NSDictionary *)customHTTPHeaders {
    [super customHTTPHeaders];
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:[AppUtilityClass getUserEmail]], @"application/json",[AppUtilityClass getUserEmail]] forKeys:@[@"Checksum", @"Content-Type", kEmailKey]];
    return dictionay;
}

@end

@implementation IRSDCGetStationTasks

- (NSString *)urlForAPIRequest{
    [super urlForAPIRequest];
    return [NSString stringWithFormat:@"%@/IRSDCGetStationTasks",[super baseURL]];
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    [super parseAPIResponse:responseDictionary];
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    self.percentageCompleted = [apiDataSource[@"PercentageTaskCompleted"] integerValue];
    if ([apiDataSource[@"tasks"] isKindOfClass:[NSArray class]]) {
        NSArray *tasksDataSource = apiDataSource[@"tasks"];
        [[CoreDataManager sharedManager] saveStationTasks:tasksDataSource forStationId:self.stationId];
        for (NSDictionary *tasksDictionary in tasksDataSource) {
            NSDictionary *subTasks = [tasksDictionary valueForKey:@"subTasks"];
            if ([subTasks[@"subActivities"] isKindOfClass:[NSArray class]]) {
                NSArray *subTasksDataSource = subTasks[@"subActivities"];
                [[CoreDataManager sharedManager] saveSubTasks:subTasksDataSource forTaskId:[tasksDictionary valueForKey:@"refId"]];
            }
        }
    }
}

- (NSDictionary *)customHTTPHeaders {
    [super customHTTPHeaders];
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.stationId], @"application/json",self.stationId] forKeys:@[@"Checksum", @"Content-Type", kStationIdKey]];
    return dictionay;
}

@end

@implementation IRSDCGetStationSubTasks
- (NSString *)urlForAPIRequest{
    [super urlForAPIRequest];
    return [NSString stringWithFormat:@"%@/IRSDCGetStationSubTasks",[super baseURL]];
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    [super parseAPIResponse:responseDictionary];
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    self.activityName = apiDataSource[@"activityName"];
    self.editStatus = [apiDataSource[@"editStatus"] boolValue];
    if ([apiDataSource[@"subActivities"] isKindOfClass:[NSArray class]]) {
        NSArray *subTasksDataSource = apiDataSource[@"subActivities"];
        [[CoreDataManager sharedManager] saveSubTasks:subTasksDataSource forTaskId:self.taskId];
    }
}

- (NSDictionary *)customHTTPHeaders {
    [super customHTTPHeaders];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.taskId], @"application/json",[AppUtilityClass getUserEmail], self.taskId, self.stationId] forKeys:@[@"Checksum", @"Content-Type", kEmailKey, kTaskIdKey, kStationIdKey]];
    return dictionary;
}

@end

