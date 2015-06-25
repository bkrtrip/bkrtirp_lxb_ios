//
//  AFAppDotNetAPIClient.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
