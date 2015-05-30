//
//  AppMacro.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#ifndef LXBtrip_AppMacro_h
#define LXBtrip_AppMacro_h

#import "ToolMacro.h"
#import "Single.h"
#import "MicroShopInfo.h"
#import "HTTPTool.h"
#import "User.h"
#import "CommentInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

// 服务器地址
#define HOST_BASE_URL @"http://api.bkrtrip.com/"
#define HOST_IMG_BASE_URL @"http://www.lrtrip.com/image"

// NavBasedViewController
#define MainNavTitleColor RGB(255, 255, 255)
#define MainNavTitleFont [UIFont boldSystemFontOfSize:18]

// Micro shop
#define LIST_HOR_MARGIN 10.f
#define LIST_HOR_SPACING 10.f
#define LIST_VER_MARGIN 10.f
#define LIST_VER_SPACING 10.f
#define LIST_WIDTH_HEIGHT_PROPORTION (310.f/520.f)
#define Num_Of_Images_Per_Row 2

#define DELETE_ACTION_SHEET_HEIGHT 187.f


#define TEXT_SELECTED_COLOR [UIColor colorWithRed:76/255.f green:165/255.f blue:255/255.f alpha:1]

// 999999
#define TEXT_999999 [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1]

// 666666
#define TEXT_666666 [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]
// FF0075
#define RED_FF0075 [UIColor colorWithRed:255/255.f green:0/255.f blue:117/255.f alpha:1]

// F8F8F8 248
#define BG_F8F8F8 [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1]

// F5F5F5
#define BG_F5F5F5 [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1]



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


typedef enum ShopUsedStatus
{
    SHOP_IS_USE = 0, // 使用
    SHOP_NOT_USE = 1, // 未使用
} ShopUsedStatus;






#endif
