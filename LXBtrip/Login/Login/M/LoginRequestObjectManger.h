//
//  LoginRequestObjectManger.h
//  LXBtrip
//
//  Created by gongyucheng on 15/5/15.
//  Copyright (c) 2015年 LXB. All rights reserved.
//
//登陆数据请求类
#import <Foundation/Foundation.h>
typedef void (^LoginRequestFinishedBlock)(int state);//state 等于0代表成功，1为账号或密码错误，2为网络失败
@interface LoginRequestObjectManger : NSObject
//参数，username账户名,password密码，block回调
+(void)loginRequestNumberStr:(NSString *)userName password:(NSString *)password finished:(LoginRequestFinishedBlock)block;
@end
