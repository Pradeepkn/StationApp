//
//  UploadImagesApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/17/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface UploadImagesApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSArray *images;

@end
