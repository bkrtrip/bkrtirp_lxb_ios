//
//  User.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/12.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)initWithUserID:(NSNumber *)userID userName:(NSString *)userName userPasssword:(NSString *)userPassword userHead:(NSString *)userHead wdContacts:(NSString *)wdContacts wdName:(NSString *)wdName userPhone:(NSString *)userPhone provinceID:(NSString *)provinceID provinceName:(NSString *)provinceName ciytID:(NSString *)cityID cityName:(NSString *)cityName{
    if (self == [super init]) {
        self.userID = userID;//用户id
        self.userName = userName;//用户名
        self.userPassword = userPassword;//用户密码
        self.userHead = userHead;//用户头像
        self.wdContacts = wdContacts;//微店联系人
        self.wdName = wdName;//微店名称
        self.userPhone = userPhone;//联系电话
        self.provinceID = provinceID;//所在省id
        self.provinceName = provinceName;//所在省名称
        self.cityID = cityID;//所在城市id
        self.cityName = cityName;//所在城市名称
    }
    return self;
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        //这里是返回参数
    }
    return self;
}
@end
