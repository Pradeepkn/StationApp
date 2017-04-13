//
//  UpdateSubTasksStatusApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "UpdateSubTasksStatusApi.h"
#import "ApiKeys.h"
#import "AppConstants.h"
#import "AppUtilityClass.h"

@implementation UpdateSubTasksStatusApi

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if ([AppUtilityClass isEOLSelected]) {
        return [NSString stringWithFormat:@"%@/EOIUpdateSubtaskStatus",[super baseURL]];
    }else if ([AppUtilityClass isIRSDCSelected]) {
        return [NSString stringWithFormat:@"%@/IRSDCUpdateSubtaskStatus",[super baseURL]];
    }
    return [NSString stringWithFormat:@"%@/updateSubtaskStatus",[super baseURL]];
}

- (NSMutableDictionary *)requestParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:@[self.stationSubActivityId, self.remarks,[NSNumber numberWithInteger:self.status]] forKeys:@[kStationSubActivityIdKey, kRemarks, kStatusKey]];
    return parameters;
}

- (NSString *)requestType{
    return APIPost;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionary;
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[AppUtilityClass calculateSHA:self.stationSubActivityId], @"Checksum", @"application/json", @"Content-Type",nil];
    return dictionary;
}

- (NSString *)customRawBody {
    NSDictionary *rawBody = [NSDictionary dictionaryWithObjects:@[self.stationSubActivityId, [NSNumber numberWithInteger:self.status], self.remarks] forKeys:@[kStationSubActivityIdKey, kStatusKey, kRemarks]];
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
