//
//  WhatsNewMessagesApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/15/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "WhatsNewMessagesApi.h"
#import "AppUtilityClass.h"
#import "CoreDataManager.h"
#import "AppConstants.h"

@implementation WhatsNewMessagesApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/getWhatsNewMessages",[super baseURL]];
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
    if ([apiDataSource[@"whatsNewMessages"] isKindOfClass:[NSArray class]]) {
        NSArray *whatsNewDataSource = apiDataSource[@"whatsNewMessages"];
        [[CoreDataManager sharedManager] saveWhatsNewMessages:whatsNewDataSource];
    }
}

@end
