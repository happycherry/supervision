//
//  myNetworking.m
//  hbj_app
//
//  Created by eidision on 14/12/8.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "myNetworking.h"

static NSString * const HuijinAPIBaseURLString = @"http://192.168.0.51:8080/MServer/rest/";

@implementation myNetworking

+ (instancetype)sharedClient {
    static myNetworking *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[myNetworking alloc] initWithBaseURL:[NSURL URLWithString:HuijinAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
        //_sharedClient.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    });
    
    return _sharedClient;
}

@end
