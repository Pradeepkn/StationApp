//
//  StaionGalleryInfoApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/16/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface StaionGalleryInfoApi : APIBase

@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *established;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *avgPassengerFootfail;
@property (nonatomic, strong) NSArray *weekKeys;

@property (nonatomic, assign) BOOL editStatus;
@end
