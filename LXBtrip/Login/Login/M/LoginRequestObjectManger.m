//
//  LoginRequestObjectManger.m
//  LXBtrip
//
//  Created by gongyucheng on 15/5/15.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "LoginRequestObjectManger.h"
#import "AFNetworking.h"
@implementation LoginRequestObjectManger
+(void)loginRequestNumberStr:(NSString *)userName password:(NSString *)password finished:(LoginRequestFinishedBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:@"username",userName,@"password",password,nil];
    [manager POST:[NSString stringWithFormat:@"%@/my/login",LXURL] parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //解析返回参数，回调给调用的vc
         if (responseObject)//如果登陆成功，返回给vc，然后进入相应的界面
         {
               block(1);
         }else
         {
             block(0);
         }
       
      
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         block(2);//如果失败了回调给vc，调用相应的提醒
     }];

}
@end
