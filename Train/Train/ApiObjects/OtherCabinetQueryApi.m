//
//  OtherCabinetQueryApi.m
//  Train
//
//  Created by pradeep on 4/11/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "OtherCabinetQueryApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation OtherCabinetQueryApi

-(instancetype)init{
    if(self = [super init]){

    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/othersCabinetQuery",[super baseURL]];
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
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    [[CoreDataManager sharedManager] saveQueries:apiDataSource[@"queriesData"] forStation:@"othersCabinetQuery"];
}

@end
