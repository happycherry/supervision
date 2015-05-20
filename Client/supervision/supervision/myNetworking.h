//
//  myNetworking.h
//  hbj_app
//
//  Created by eidision on 14/12/8.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface myNetworking : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
