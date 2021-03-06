//
//  GetStationTasksApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GetStationTasksApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation GetStationTasksApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isEOLSelected]) {
        return [NSString stringWithFormat:@"%@/EOIGetStationTasks",[super baseURL]];
    }
    if ([AppUtilityClass isFirstPhaseSelected]) {
        return [NSString stringWithFormat:@"%@/getStationTasks",[super baseURL]];
    }else {
        return [NSString stringWithFormat:@"%@/nextPhaseGetStationTasks",[super baseURL]];
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
    NSMutableDictionary *dictionay;
    if ([AppUtilityClass isEOLSelected]) {
        dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:[AppUtilityClass getUserEmail]], @"application/json",[AppUtilityClass getUserEmail]] forKeys:@[@"Checksum", @"Content-Type", kEmailKey]];
    }else {
        dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.stationId], @"application/json",self.stationId] forKeys:@[@"Checksum", @"Content-Type", kStationIdKey]];
    }

    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    self.percentageCompleted = [apiDataSource[@"PercentageTaskCompleted"] integerValue];
    if ([apiDataSource[@"tasks"] isKindOfClass:[NSArray class]]) {
        NSArray *tasksDataSource = apiDataSource[@"tasks"];
        [[CoreDataManager sharedManager] saveStationTasks:tasksDataSource forStationId:self.stationId];
    }
}

@end
