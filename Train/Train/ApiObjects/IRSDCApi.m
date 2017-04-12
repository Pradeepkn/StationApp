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
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:[AppUtilityClass getUserEmail]], @"application/json",[AppUtilityClass getUserEmail]] forKeys:@[@"Checksum", @"Content-Type", kEmailKey]];
    return dictionay;
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
    }
}

@end

@implementation IRSDCGetStationSubTasks

@end

