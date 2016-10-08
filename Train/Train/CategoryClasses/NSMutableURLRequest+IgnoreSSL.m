//
//  NSMutableURLRequest+IgnoreSSL.m
//  PaySay
//
//  Created by Pradeep Narendra on 8/23/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "NSMutableURLRequest+IgnoreSSL.h"

@implementation NSMutableURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
}

@end
