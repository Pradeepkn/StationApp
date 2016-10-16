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
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/getStationInfo",[super baseURL]];
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
    if ([apiDataSource[@"images"] isKindOfClass:[NSArray class]]) {
        NSArray *arrayOfImages = apiDataSource[@"images"];
        NSDictionary *weeklyImges =  [arrayOfImages firstObject];
        self.weekKeys = [NSArray arrayWithArray:[weeklyImges allKeys]];
        for (NSString *weekKey in self.weekKeys) {
            [[CoreDataManager sharedManager] saveStationGalleryInfoImages:weeklyImges[weekKey] forKey:weekKey];
        }
    }
    if ([apiDataSource[@"stationData"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *stationData in apiDataSource[@"stationData"]) {
            self.stationName = stationData[@"stationName"];
            self.established = stationData[@"established"];
            self.area = stationData[@"area"];
            self.avgPassengerFootfail = stationData[@"avgPassengerFootfail"];
        }
    }
}

@end
