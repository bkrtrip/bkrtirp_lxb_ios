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

// 获取我的微店列表 - LXB1125
+ (void)getMyMicroShopListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 获取微店详情 - LXB1113
+ (void)getMicroShopDetailWithShopId:(NSNumber *)shopId success:(SuccessBlock)success fail:(FailBlock)fail;






















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
