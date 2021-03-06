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
        self.subActivitiesArray = [[NSMutableArray alloc] init];
        self.remarksArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isEOLSelected]) {
        return [NSString stringWithFormat:@"%@/EOIGetStationSubTasks",[super baseURL]];
    }
    if ([AppUtilityClass isFirstPhaseSelected]) {
        return [NSString stringWithFormat:@"%@/getStationSubTasks",[super baseURL]];
    }else {
        return [NSString stringWithFormat:@"%@/nextPhaseGetStationSubTasks",[super baseURL]];
    }
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
    NSMutableDictionary *dictionary;
    if ([AppUtilityClass isEOLSelected]) {
        dictionary = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.taskId], @"application/json",self.email, self.taskId] forKeys:@[@"Checksum", @"Content-Type", kEmailKey, kTaskIdKey]];
    }else {
        dictionary = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.taskId], @"application/json",self.email, self.taskId, self.stationId] forKeys:@[@"Checksum", @"Content-Type", kEmailKey, kTaskIdKey, kStationIdKey]];
    }

    return dictionary;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    self.activityName = apiDataSource[@"activityName"];
    self.editStatus = [apiDataSource[@"editStatus"] boolValue];
    if ([apiDataSource[@"subActivities"] isKindOfClass:[NSArray class]]) {
        NSArray *subTasksDataSource = apiDataSource[@"subActivities"];
        [[CoreDataManager sharedManager] saveSubTasks:subTasksDataSource forTaskId:self.taskId];
    }
}

@end
