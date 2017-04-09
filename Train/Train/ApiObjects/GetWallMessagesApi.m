//
//  GetWallMessages.m
//  Train
//
//  Created by Pradeep Narendra on 10/15/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GetWallMessagesApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation GetWallMessagesApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isFirstPhaseSelected]) {
        return [NSString stringWithFormat:@"%@/stationDashboard",[super baseURL]];
    }else {
        return [NSString stringWithFormat:@"%@/nextPhaseStationDashboard",[super baseURL]];
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
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.email], @"application/json",self.email] forKeys:@[@"Checksum", @"Content-Type", kEmailKey]];
    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSArray *apiDataSource = responseDictionary[@"data"];
    for (NSDictionary *apiDataDict in apiDataSource) {
//        NSArray *stationsDataSource = apiDataDict[@"stations"];
//        [[CoreDataManager sharedManager] saveStations:stationsDataSource forPhase:<#(NSInteger)#>];
        NSArray *messagesDataSource = apiDataDict[@"messages"];
        [[CoreDataManager sharedManager] saveMessages:messagesDataSource forPhase:[AppUtilityClass isFirstPhaseSelected]?1:2];
        NSArray *imagesDataSource = apiDataDict[@"images"];
        [[CoreDataManager sharedManager] saveHomeImages:imagesDataSource forPhase:[AppUtilityClass isFirstPhaseSelected]?1:2];
    }
}

@end
