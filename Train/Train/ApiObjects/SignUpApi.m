//
//  SignUpApi.m
//  PaySay
//
//  Created by Pradeep Narendra on 6/28/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SignUpApi.h"
#import "ApiKeys.h"
#import "AppConstants.h"

@implementation SignUpApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/registerUser",[super baseURL]];
}

- (NSMutableDictionary *)requestParameters{
    return [NSMutableDictionary dictionaryWithObjects:@[self.email,self.password, self.stationName, self.designation, self.firstName, self.lastName] forKeys:@[kEmailKey,kPasswordKey, kStationName, kDesignation, kFirstName, kLastName]];
}

- (NSString *)requestType{
    return APIPost;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionay = [NSDictionary dictionaryWithObjectsAndKeys:@"email", @"Checksum", @"application/json", @"Content-Type",nil];
    return dictionay;
}

- (NSString *)apiAuthenticationAccessToken{
    return nil;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    
}


@end
