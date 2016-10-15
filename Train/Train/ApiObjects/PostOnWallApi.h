//
//  PostOnWallApi.h
//  Train
//
//  Created by Pradeep Narendra on 10/15/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface PostOnWallApi : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *designation;

@end
