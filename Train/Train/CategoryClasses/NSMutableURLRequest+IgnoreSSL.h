//
//  NSMutableURLRequest+IgnoreSSL.h
//  PaySay
//
//  Created by Pradeep Narendra on 8/23/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end
