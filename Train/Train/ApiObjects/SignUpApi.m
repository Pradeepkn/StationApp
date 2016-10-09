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
#import "AppUtilityClass.h"

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
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:@[self.email,self.password, self.stationName, self.designation, self.firstName, self.lastName] forKeys:@[kEmailKey,kPasswordKey, kStationName, kDesignation, kFirstName, kLastName]];
    return parameters;
}

- (NSString *)requestType{
    return APIPost;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionay = [NSDictionary dictionaryWithObjectsAndKeys:[AppUtilityClass calculateSHA:self.email], @"Checksum", @"application/json", @"Content-Type",nil];
    return dictionay;
}

- (NSString *)customRawBody {
    NSDictionary *rawBody = [NSDictionary dictionaryWithObjects:@[self.email,self.password, self.stationName, self.designation, self.firstName, self.lastName] forKeys:@[kEmailKey,kPasswordKey, kStationName, kDesignation, kFirstName, kLastName]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rawBody
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (NSString *)apiAuthenticationAccessToken{
    return nil;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    
}


@end
