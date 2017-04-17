//
//  GetStationDesignationApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GetStationDesignationApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation GetStationDesignationApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isIRSDCSelected]) {
        return [NSString stringWithFormat:@"%@/getIrsdcStations",[super baseURL]];
    }else if ([AppUtilityClass isFirstPhaseSelected]) {
        return [NSString stringWithFormat:@"%@/stations",[super baseURL]];
    }else {
        return [NSString stringWithFormat:@"%@/nextPhaseStations",[super baseURL]];
    }
}

- (NSMutableDictionary *)requestParameters{
    return nil;
}

- (NSString *)requestType{
    return APIGet;//APIPost;
}

- (NSString *)apiAuthenticationAccessToken{
    return nil;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionay = [NSDictionary dictionaryWithObjectsAndKeys:[AppUtilityClass calculateSHA:@"stationapp"], @"Checksum", @"application/json", @"Content-Type",nil];
    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSArray *apiDataSource = responseDictionary[@"data"];
    for (NSDictionary *apiDataDict in apiDataSource) {
        NSArray *stationsDataSource = apiDataDict[@"stations"];
        if ([AppUtilityClass isIRSDCSelected]) {
            [[CoreDataManager sharedManager] saveIRSDCStations:stationsDataSource forPhase:kIRSDCType];
        }else {
            [[CoreDataManager sharedManager] saveStations:stationsDataSource forPhase:[AppUtilityClass isFirstPhaseSelected]?kFirstPhase:kSecondPhase];
        }
        NSArray *designationsDataSource = apiDataDict[@"designation"];
        [[CoreDataManager sharedManager] saveDesignations:designationsDataSource forPhase:[AppUtilityClass isFirstPhaseSelected]?kFirstPhase:kSecondPhase];
    }
}

@end
