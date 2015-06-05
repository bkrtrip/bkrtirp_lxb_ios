//
//  HTTPTool.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/11.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppMacro.h"

typedef void(^SuccessBlock)(id result); // 成功时回调的代码块
typedef void(^FailBlock)(id result); // 失败时回调的代码块

@interface HTTPTool : NSObject
singleton_interface(HTTPTool)


// 获取在线微店列表 - LXB1111 - 未登录
+ (void)getOnlineMicroShopListWithProvince:(NSString *)province success:(SuccessBlock)success fail:(FailBlock)fail;

// 获取在线微店列表 - LXB1122 - 已登录
+ (void)getOnlineMicroShopListWithProvince:(NSString *)province companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 获取我的微店列表 - LXB1125 - 已登录
+ (void)getMyMicroShopListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 获取我的微店列表 - LXB11148 - 未登录
+ (void)getMyMicroShopListWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取微店详情 - LXB1113
+ (void)getMicroShopDetailWithShopId:(NSNumber *)shopId success:(SuccessBlock)success fail:(FailBlock)fail;

// 添加到我的微店 - LXB1224
+ (void)addToMyShopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 锁定微店 - LXB13244
+ (void)lockMicroshopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;






// 专线/地接 - 未登录 - LXB2119
+ (void)getSuppliersListWithStartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 专线/地接 - 已登录 - LXB21210
+ (void)getSuppliersListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId StartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 供应商详情 - 未登录 - LXB21115
+ (void)getSupplierDetailWithSupplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSNumber *)isMy success:(SuccessBlock)success fail:(FailBlock)fail;

// 供应商详情 - 已登录 - LXB21216
+ (void)getSupplierDetailWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId supplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSNumber *)isMy success:(SuccessBlock)success fail:(FailBlock)fail;

// 我的供应商 - LXB21218
+ (void)getMySuppliersWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId lineClass:(NSString *)lineClass success:(SuccessBlock)success fail:(FailBlock)fail;

// 筛选供应商 - LXB21111
+ (void)getSiftedSuppliersWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;




// 获取国家 - LXB51139
+ (void)getCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取省份 - LXB51140
+ (void)getProvincesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取城市 - LXB51141
+ (void)getCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取热门城市 - LXB51142
+ (void)getHotCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取热门国家 - LXB51143
+ (void)getHotCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;













///*
// *GET方式请求HTTP/ POST方式请求HTTP
// *url:url字符串
// *params:参数
// *contentType:接收响应类型
// *success:请求成功代码块
// *fail：请求失败代码块
// */
//+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;
//
//+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;
//
///*
// * Http的multipart的POST请求（上传文件用）
// */
//+ (void)multipartPostWithUrl:(NSString *)urlStr params:(NSDictionary *)params fileDatas:(NSArray *)datas contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;
///*
// * 异步下载图片(AFNetworking)
// */
//+ (void)downloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView;
//
///*
// * 异步下载图片(系统方法)
// */
//+ (void)systemDownloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView;

@end
