//
//  DeleteMessageApi.m
//  Train
//
//  Created by Pradeep Narendra on 10/26/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "DeleteMessageApi.h"
#import "ApiKeys.h"
#import "AppConstants.h"
#import "AppUtilityClass.h"

@implementation DeleteMessageApi


-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (NSString *)urlForAPIRequest{
    if (self.isInfoMessage) {
        return [NSString stringWithFormat:@"%@/deleteInfoMessage",[super baseURL]];
    }
    return [NSString stringWithFormat:@"%@/deleteWhatsNewMessage",[super baseURL]];
}

- (NSMutableDictionary *)requestParameters{
    return nil;
}

- (NSString *)requestType{
    return APIPost;
}

- (NSDictionary *)customHTTPHeaders {
    NSDictionary *dictionary = [NSDictionary
                                dictionaryWithObjects:@[
                                                        [AppUtilityClass calculateSHA:self.email],
                                                        @"application/json",
                                                        self.email,
                                                        self.messageId]
                                forKeys:@[
                                          @"Checksum",
                                          @"Content-Type",
                                          kEmailKey,
                                          kMessageIDKey]];
    return dictionary;
}

- (NSString *)customRawBody {
    return nil;
}

- (NSString *)apiAuthenticationAccessToken{
    return nil;
}

- (void)parseAPIResponse:(NSDictionary *)responseDictionary{
    
}

@end
