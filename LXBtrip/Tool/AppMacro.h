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
#import "TourInfo.h"
#import "CommentInfo.h"
#import "SupplierInfo.h"
#import "SupplierProduct.h"
#import "City.h"
#import "Province.h"
#import "Country.h"
#import "HotCity.h"
#import "HotCountry.h"
#import "SiftedLine.h"
#import "HotSearch.h"
#import "MyOrderItem.h"
#import "AlleyInfo.h"
#import "UserModel.h"
#import "CustomActivityIndicator.h"

#import <SDWebImage/UIImageView+WebCache.h>

// 服务器地址
#define HOST_BASE_URL @"http://api.bkrtrip.com/"
#define HOST_IMG_BASE_URL @"http://www.lrtrip.com/image"

// NavBasedViewController
#define MainNavTitleColor RGB(255, 255, 255)
#define MainNavTitleFont [UIFont boldSystemFontOfSize:18]

// Micro shop collection view
#define LIST_HOR_MARGIN_MICROSHOP 10.f
#define LIST_HOR_SPACING_MICROSHOP 10.f
#define LIST_VER_MARGIN_MICROSHOP 10.f
#define LIST_VER_SPACING_MICROSHOP 10.f
#define LIST_WIDTH_HEIGHT_PROPORTION_MICROSHOP (310.f/520.f)
#define NUM_OF_IMAGES_PER_ROW_MICROSHOP 2

// Supplier collection view
#define LIST_HOR_MARGIN_SUPPLIER 10.f
#define LIST_HOR_SPACING_SUPPLIER 10.f
#define LIST_VER_MARGIN_SUPPLIER 10.f
#define LIST_VER_SPACING_SUPPLIER 10.f
#define LIST_WIDTH_HEIGHT_PROPORTION_SUPPLIER (226.f/77.f)
#define NUM_OF_IMAGES_PER_ROW_SUPPLIER 3

// Sift supplier collection view
#define LIST_HOR_MARGIN_SIFT_SUPPLIER 10.f
#define LIST_HOR_SPACING_SIFT_SUPPLIER 10.f
#define LIST_VER_MARGIN_SIFT_SUPPLIER 10.f
#define LIST_VER_SPACING_SIFT_SUPPLIER 10.f
#define LIST_WIDTH_HEIGHT_PROPORTION_SIFT_SUPPLIER (104.f/74.f)
#define NUM_OF_IMAGES_PER_ROW_SIFT_SUPPLIER 4

// Alley collection view
#define LIST_HOR_MARGIN_ALLEY 0.f
#define LIST_HOR_SPACING_ALLEY 0.f
#define LIST_VER_MARGIN_ALLEY 0.f
#define LIST_VER_SPACING_ALLEY 0.f
#define LIST_WIDTH_HEIGHT_PROPORTION_ALLEY (210.f/150.f)
#define NUM_OF_IMAGES_PER_ROW_ALLEY 2

#define TEXT_SELECTED_COLOR [UIColor colorWithRed:76/255.f green:165/255.f blue:255/255.f alpha:1]

// CCCCD2
#define TEXT_CCCCD2 [UIColor colorWithRed:204/255.f green:204/255.f blue:210/255.f alpha:1]

// 999999
#define TEXT_999999 [UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1]

// 666666
#define TEXT_666666 [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1]

// 333333
#define TEXT_333333 [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1]

// 00AE55
#define TEXT_00AE55 [UIColor colorWithRed:0/255.f green:174/255.f blue:85/255.f alpha:1]

// FF0075
#define RED_FF0075 [UIColor colorWithRed:255/255.f green:0/255.f blue:117/255.f alpha:1]

// F8F8F8 248
#define BG_F8F8F8 [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1]

// E9ECF5 248
#define BG_E9ECF5 [UIColor colorWithRed:233/255.f green:236/255.f blue:245/255.f alpha:1]

// F5F5F5
#define BG_F5F5F5 [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1]

// 4CA5FF - BLUE
#define TEXT_4CA5FF [UIColor colorWithRed:76/255.f green:165/255.f blue:255/255.f alpha:1]

//  code	常用返回码
typedef enum ErrorCodeType
{
    ERROR_CODE_ERROR = -1,//错误
    ERROR_CODE_SUCCESSFUL = 0,//成功
    ERROR_CODE_NO_DATA = 90001, //查询无数据
    ERROR_CODE_TOKEN_INVALID = 90002, //TOKEN不合法
    ERROR_CODE_CODE_ILLEGAL = 90003, //接口CODE不合法
    ERROR_CODE_MISSING_ARGUMENT = 90004,	// 缺少参数
    ERROR_CODE_ARGUMENT_ILLEGAL = 90005,  // 参数不合法
    ERROR_CODE_DATE_FORMAT_INCORRECT = 90006,	// 日期格式错误
} ErrorCodeType;


typedef enum TemplateType
{
    Exclusive_Shop = 0, // 专卖
    Template_By_LXB = 1, // 模板（旅小宝提供）
    Template_By_Supplier = 2, // 模板（供应商提供）
} TemplateType;

typedef enum TemplateDefaultStatus
{
    Is_Locked = 0, // 0：锁定
    Is_Default = 1, // 1：默认
    Is_Else = 2, // 2：其他
}TemplateDefaultStatus;

typedef enum ShopUsedStatus
{
    SHOP_IS_USE = 0, // 使用
    SHOP_NOT_USE = 1, // 未使用
} ShopUsedStatus;

typedef enum SupplierStatus
{
    invite_supplier = -1, // 加号，邀请supplier
    supplier_isMy_isNew = 0, // 我的 + 最新
    supplier_isMy_notNew = 1, // 我的 + 非最新
    supplier_notMy_isNew = 2, // 非我的 + 最新
    supplier_notMy_notNew = 3, // 非我的 + 非最新
} SupplierStatus;

typedef enum SiftedLineType
{
    Domestic_ZhuanXian = 2, // 国内 - 专线
    Abroad_ZhuanXian = 3, // 境外 - 专线
    Nearby_ZhuanXian = 4,
    Domestic_DiJie = 6,
    Abroad_DiJie = 7

} SiftedLineType;

typedef enum OrderListType
{
    Order_Not_Confirm = 0,
    Order_Confirmed = 1,
    Order_Invalid = 2
}OrderListType;

typedef enum AlleyJoinStatus // 加盟状态 0：未加盟、1：待申请、 2：同意  3：拒绝  4：解除
{
    Not_Join = 0,
    Apply_Wait = 1,
    Apply_Agreed = 2,
    Apply_Denied = 3,
    Join_released = 4
}AlleyJoinStatus;

typedef enum WalkType // 
{
    All_Kinds = -1,
    Follow_Group = 0,
    Free_Run = 1,
    Half_Free = 2,
}WalkType;

typedef enum PopUpViewType
{
    None_Type = 0,
    Accompany_Type = 1,
    Preview_Type = 2,
    Share_Type = 3
} PopUpViewType;

typedef enum DropDownType
{
    No_Type = 0,
    StartCity_Type = 1,
    Travel_Type = 2
} DropDownType;

typedef enum TouristType
{
    Adult = 0,
    Kid_Bed = 1,
    Kid_No_Bed = 2
} TouristType;


//国内游  #1#283  出境游  #1#303  周边游  #1#492  国内目的地  #1#997  国外目的地  #1#998
#define LINE_CLASS @{@0:@"#1#283", @1:@"#1#303", @2:@"#1#492", @3:@"#1#997", @4:@"#1#998"}

#endif
