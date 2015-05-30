//
//  User.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/12.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong,nonatomic)NSString *userID;//用户ID
@property (strong,nonatomic)NSString *userName;//用户名
@property (strong,nonatomic)NSString *userPassword;//用户密码
@property (strong,nonatomic)NSString *userHead;//用户头像
@property (strong,nonatomic)NSString *wdContacts;//微店联系人
@property (strong,nonatomic)NSString *wdName;//微店名称
@property (strong,nonatomic)NSString *userPhone;//联系电话
@property (strong,nonatomic)NSString *provinceID;//所在省ID
@property (strong,nonatomic)NSString *provinceName;//所在省名称
@property (strong,nonatomic)NSString *cityID;//所在市ID
@property (strong,nonatomic)NSString *cityName;//所在市名称


@property (copy,nonatomic) NSNumber *companyId;
@property (copy,nonatomic) NSNumber *staffId;
@property (copy,nonatomic) NSNumber *token;

-(instancetype)initWithUserID:(NSString *)userID userName:(NSString *)userName userPasssword:(NSString *)userPassword userHead:(NSString *)userHead wdContacts:(NSString *)wdContacts wdName:(NSString *)wdName userPhone:(NSString *)userPhone provinceID:(NSString *)provinceID provinceName:(NSString *)provinceName ciytID:(NSString *)cityID cityName:(NSString *)cityName;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
