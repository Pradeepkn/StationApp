//
//  StaionGalleryInfoApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StaionGalleryInfoApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation StaionGalleryInfoApi

-(instancetype)init{
    if(self = [super init]){
        self.weekKeys = [[NSArray alloc] init];
        self.stationData = [[NSArray alloc] init];
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isFirstPhaseSelected]) {
        return [NSString stringWithFormat:@"%@/getStationInfo",[super baseURL]];
    }else {
        return [NSString stringWithFormat:@"%@/nextPhaseGetStationInfo",[super baseURL]];
    }
//    return @"http://www.mocky.io/v2/58094802100000260f4c63bb";
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
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.stationId], @"application/json",self.email, self.stationId] forKeys:@[@"Checksum", @"Content-Type", kEmailKey, kStationIdKey]];
    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    if ([apiDataSource[@"images"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *imagesDictionary = apiDataSource[@"images"];
        self.weekKeys = [NSArray arrayWithArray:[imagesDictionary allKeys]];
        for (NSString *weekKey in self.weekKeys) {
            [[CoreDataManager sharedManager] saveStationGalleryInfoImages:imagesDictionary[weekKey] forKey:weekKey];
        }
    }
    self.editStatus = [apiDataSource[@"editStatus"] boolValue];
    if ([apiDataSource[@"stationData"] isKindOfClass:[NSArray class]]) {
        self.stationData = apiDataSource[@"stationData"];
        NSDictionary *stationDataDict = [self.stationData firstObject];
        if (stationDataDict.allKeys.count < 1) {
            self.stationData = nil;
        }
        for (NSDictionary *stationData in apiDataSource[@"stationData"]) {
            self.stationName = stationData[@"stationName"]?:@"NA";
            self.established = stationData[@"established"]?:@"NA";
            self.area = stationData[@"area"]?:@"NA";
            self.avgPassengerFootfail = stationData[@"avgPassengerFootfail"]?:@"NA";
            self.stateName = stationData[@"state"]?:@"NA";
            self.zoneName = stationData[@"zone"]?:@"NA";
            self.divisionName = stationData[@"division"]?:@"NA";
            self.stationCode = stationData[@"stationCode"]?:@"NA";
        }
    }
    [[CoreDataManager sharedManager] saveQueries:apiDataSource[@"queriesData"] forStation:self.stationName];
}

@end
