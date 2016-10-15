//
//  SendWhatsNewMessage.h
//  Train
//
//  Created by Pradeep Narendra on 10/15/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <TTPLAPIManager/TTPLAPIManager.h>

@interface SendWhatsNewMessage : APIBase

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *stationId;

@end
