//
//  AppMacro.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#ifndef LXBtrip_AppMacro_h
#define LXBtrip_AppMacro_h

#import "Single.h"
#import "MicroShopInfo.h"
#import "HTTPTool.h"
#import "User.h"


// 服务器地址
#define HOST_BASE_URL @"http://xxxx/"
#define HOST_IMG_BASE_URL @"http://xxxx/"

// 屏幕
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// Micro shop
#define LIST_HOR_MARGIN 10
#define LIST_HOR_SPACING 10
#define LIST_VER_MARGIN 10
#define LIST_VER_SPACING 10
#define LIST_WIDTH_HEIGHT_PROPORTION 310.f/520.f
#define Num_Of_Images_Per_Row 2

//  code	常用返回码
typedef enum ErrorCodeType
{
    ERROR_CODE_SUCCESSFUL = 0,//成功
    ERROR_CODE_NO_DATA = 90001, //查询无数据
    ERROR_CODE_TOKEN_INVALID = 90002, //TOKEN不合法
    ERROR_CODE_CODE_ILLEGAL = 90003, //接口CODE不合法
    ERROR_CODE_MISSING_ARGUMENT = 90004,	// 缺少参数
    ERROR_CODE_ARGUMENT_ILLEGAL = 90005,  // 参数不合法
    ERROR_CODE_DATE_FORMAT_INCORRECT = 90006,	// 日期格式错误
} ErrorCodeType;







#endif
