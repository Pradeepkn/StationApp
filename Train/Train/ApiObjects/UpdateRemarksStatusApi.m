//
//  UpdateRemarksStatusApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/19/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "UpdateRemarksStatusApi.h"
#import "ApiKeys.h"
#import "AppConstants.h"
#import "AppUtilityClass.h"

@implementation UpdateRemarksStatusApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    return [NSString stringWithFormat:@"%@/updateRemarks",[super baseURL]];
}

- (NSMutableDictionary *)requestParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:@[self.remarksId, [NSNumber numberWithInteger:self.status]] forKeys:@[kStationRemarksIdKey, kStatusKey]];
    return parameters;
}

- (NSString *)requestType{
    return APIPost;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[AppUtilityClass calculateSHA:self.remarksId], @"Checksum", @"application/json", @"Content-Type",nil];
    return dictionary;
}

- (NSString *)customRawBody {
    NSDictionary *rawBody = [NSDictionary dictionaryWithObjects:@[self.remarksId, [NSNumber numberWithInteger:self.status]] forKeys:@[kStationRemarksIdKey, kStatusKey]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rawBody
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
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
