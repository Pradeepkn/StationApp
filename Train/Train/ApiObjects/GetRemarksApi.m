//
//  GetRemarksApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/19/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "GetRemarksApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation GetRemarksApi

-(instancetype)init{
    if(self = [super init]){
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/getRemarks",[super baseURL]];
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
    NSMutableDictionary *dictionay = [NSMutableDictionary dictionaryWithObjects:@[[AppUtilityClass calculateSHA:self.taskId], @"application/json", self.taskId] forKeys:@[@"Checksum", @"Content-Type", kTaskIdKey]];
    return dictionay;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    NSDictionary *apiDataSource = responseDictionary[@"data"];
    if ([apiDataSource[@"remarks"] isKindOfClass:[NSArray class]]) {
        NSArray *subTasksDataSource = apiDataSource[@"remarks"];
        [[CoreDataManager sharedManager] saveRemarks:subTasksDataSource forTaskId:self.taskId];
    }
}

@end
