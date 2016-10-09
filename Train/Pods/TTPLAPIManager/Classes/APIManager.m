//
//  APIManager.m
//
//
//  Created by Subramanian on 11/10/14.
//  Copyright (c) 2014 Tarento Technologies Pvt Ltd. All rights reserved.
//

#import "APIManager.h"
#import "APIBase.h"
#import "ApiKeys.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"

static NSString *const RootKey = @"Root";

@implementation APIManager

#pragma mark -
#pragma mark - API Manager Shared Instance
+ (instancetype)sharedInstance {
    static APIManager *apiRequestsManagerSharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiRequestsManagerSharedInstance = [[super alloc] initUniqueInstance];
        /// Please reset the flag here is you are not using JSON Request
        /// Serializer
        apiRequestsManagerSharedInstance.isJSONRequest = NO;
    });
    return apiRequestsManagerSharedInstance;
}

- (instancetype)initUniqueInstance {
    return [super init];
}

#pragma mark - Make API request -
- (void)makeAPIRequestWithObject:(APIBase *)apiObject
            shouldAddOAuthHeader:(BOOL)shouldAddOAuthHeader
              andCompletionBlock:(void (^)(NSDictionary *,
                                           NSError *))completionCallback {
    
    AFHTTPRequestOperationManager *requestManager =
    [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestSerializer *requestSerializer;
    if (self.isJSONRequest) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    /// JSON Response Serializer
    AFJSONResponseSerializer *jsonSerializer =
    [AFJSONResponseSerializer serializerWithReadingOptions:0];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    requestManager.requestSerializer = serializer;
    
    /// XML Response Serializer
    AFXMLParserResponseSerializer *xmlSerializer =
    [AFXMLParserResponseSerializer serializer];
    /// Compound Serializer
    AFCompoundResponseSerializer *compoundSerializer =
    [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:
     @[ jsonSerializer, xmlSerializer ]];
    
    [requestManager setRequestSerializer:requestSerializer];
    
    [requestManager setResponseSerializer:compoundSerializer];
    
    [requestManager.requestSerializer
     setAuthorizationHeaderFieldWithUsername:apiObject
     .apiAuthenticationUsername
     password:apiObject
     .apiAuthenticationPassword];
    if (shouldAddOAuthHeader) {
        // TODO : OAuth Header update
    }
    
    [apiObject.customHTTPHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [requestManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSDictionary *parametersDictionary = [apiObject requestParameters];
    
    if ([apiObject.requestType isEqualToString:APIPost]) {
        /// POST
        AFHTTPRequestOperation *operation  =  [requestManager POST:apiObject.urlForAPIRequest
                                                        parameters:parametersDictionary
                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                             [apiObject updateMultipartFormData:formData];
                                         }
                                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                               [self serializeAPIResponseWithData:responseObject
                                                                              andRequestOperation:operation
                                                                                        apiObject:apiObject
                                                                               andCompletionBlock:completionCallback];
                                                           }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               NSLog(@"Error: %@", [error localizedDescription]);
                                                               completionCallback(nil, error);
                                                           }];
        [operation start];
        
    } else if ([apiObject.requestType isEqualToString:APIGet]) {
        /// GET
        [requestManager GET:apiObject.urlForAPIRequest
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self serializeAPIResponseWithData:responseObject
                                       andRequestOperation:operation
                                                 apiObject:apiObject
                                        andCompletionBlock:completionCallback];
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        completionCallback(nil, error);
                    }];
    } else if ([apiObject.requestType isEqualToString:APIDelete]) {
        ///DELETE
        AFHTTPRequestOperation *operation = [requestManager DELETE:apiObject.urlForAPIRequest
                                                        parameters:parametersDictionary
                                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                               [self serializeAPIResponseWithData:responseObject
                                                                              andRequestOperation:operation
                                                                                        apiObject:apiObject
                                                                               andCompletionBlock:completionCallback];
                                                           }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               completionCallback(nil, error);
                                                           }];
        [operation start];
    }
}

- (void)makePostAPIRequestWithObject:(APIBase *)apiObject
              andCompletionBlock: (void (^)(NSDictionary *, NSError *))completionCallback{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL: [NSURL URLWithString:apiObject.urlForAPIRequest]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [apiObject.customHTTPHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [request setHTTPBody: [[apiObject customRawBody] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
        [self serializeAPIResponseWithData:responseObject
                       andRequestOperation:operation
                                 apiObject:apiObject
                        andCompletionBlock:completionCallback];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
       completionCallback(nil, error);
    }];
    [op start];
}

#pragma mark - Serializing Response -
- (void)serializeAPIResponseWithData:(id)response
                 andRequestOperation:(AFHTTPRequestOperation *)operation
                           apiObject:(APIBase *)apiObject
                  andCompletionBlock:(void (^)(NSDictionary *,
                                               NSError *))completionCallback {
    /// Check wheater the API Response is XML or JSON. Based on the type we have
    /// to convert API response into the NSDictionary.
    NSDictionary *responseDictionary;
    if ([response isKindOfClass:[NSXMLParser class]]) {
        NSError *serializationError = nil;
        responseDictionary = [[XMLDictionaryParser sharedInstance]
                              dictionaryWithData:operation.responseData];
        if (serializationError) {
            completionCallback(nil, serializationError);
            return;
        }
    }else if ([response isKindOfClass:[NSData class]]){
        responseDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    }
    else if ([response isKindOfClass:[NSDictionary class]]){
        responseDictionary = (NSDictionary *)response;
    } else if ([response isKindOfClass:[NSArray class]]){
        responseDictionary = @{RootKey : response};
    }
    [apiObject parseAPIResponse:responseDictionary];
    completionCallback(responseDictionary, nil);
}

#pragma mark - Local File Access
- (void)parseDataFromLocalFile:(APIBase *)apiObject
            andCompletionBlock:(void (^)(NSDictionary *, NSError *))completionCallback {
    
    NSString *fileName = apiObject.localFileName;
    if (fileName.length) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
        if (filePath.length) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [apiObject parseAPIResponse:responseDictionary];
            completionCallback (responseDictionary,nil);
        }
    }
    completionCallback (nil,nil);
}

@end
