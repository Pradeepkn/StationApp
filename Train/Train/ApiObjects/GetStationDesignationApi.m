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

@implementation GetStationDesignationApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/stations",[super baseURL]];
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
        [[CoreDataManager sharedManager] saveStations:stationsDataSource];
//        for (NSDictionary *stationsObject in stationsDataSource) {
//            NSString *stationName = stationsObject[@"stationName"];
//            NSString *stationId = stationsObject[@"_id"];
//            
//        }
        NSArray *designationsDataSource = apiDataDict[@"designation"];
        [[CoreDataManager sharedManager] saveDesignations:designationsDataSource];

//        for (NSDictionary *designationsObject in designationsDataSource) {
//            NSString *designationName = designationsObject[@"designation"];
//            NSString *designationId = designationsObject[@"_id"];
//        }
    }
}


@end
