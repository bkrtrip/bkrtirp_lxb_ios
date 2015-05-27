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
#import "UIBarButtonItem+Action.h"


// 服务器地址
#define HOST_BASE_URL @"http://xxxx/"
#define HOST_IMG_BASE_URL @"http://xxxx/"

// 屏幕
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define APP_WINDOW [[UIApplication sharedApplication].windows objectAtIndex:0]

// NavBasedViewController
#define MainNavTitleColor RGB(255, 255, 255)
#define MainNavTitleFont [UIFont boldSystemFontOfSize:18]

// Micro shop
#define LIST_HOR_MARGIN 10.f
#define LIST_HOR_SPACING 10.f
#define LIST_VER_MARGIN 10.f
#define LIST_VER_SPACING 10.f
#define LIST_WIDTH_HEIGHT_PROPORTION 310.f/520.f
#define Num_Of_Images_Per_Row 2

#define DELETE_ACTION_SHEET_HEIGHT 187.f

#define TEXT_SELECTED_COLOR [UIColor colorWithRed:76/255.f green:165/255.f blue:255/255.f alpha:1]
#define TEXT_NORMAL_COLOR [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]
// FF0075
#define CUSTOM_RED_COLOR [UIColor colorWithRed:255/255.f green:0/255.f blue:117/255.f alpha:1]


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
