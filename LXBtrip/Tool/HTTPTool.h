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

// 删除微店 - LXB1426
+ (void)deleteMyShopWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId shopId:(NSNumber *)shopId success:(SuccessBlock)success fail:(FailBlock)fail;

//线路列表页 - LXB1127
+ (void)getTourListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId templateId:(NSNumber *)templateId customId:(NSString *)customId startCity:(NSString *)startCity endCity:(NSString *)endCity walkType:(NSString *)walkType lineName:(NSString *)lineName pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

//线路详情页 - LXB1128 - 已登录
+ (void)getTourDetailWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId templateId:(NSNumber *)templateId lineCode:(NSString *)code success:(SuccessBlock)success fail:(FailBlock)fail;

//线路详情页 - LXB21114 - 未登录
+ (void)getTourDetailWithLineCode:(NSString *)code success:(SuccessBlock)success fail:(FailBlock)fail;

//评论列表 - LXB51158 - 未登录
+ (void)getReviewsListWithLineCode:(NSString *)code pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

//评论列表 - LXB51245 - 已登录
+ (void)getReviewsListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId lineCode:(NSString *)code pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

//新增评论 - LXB52159 - 未登录
+ (void)postReviewWithCompanyId:(NSNumber *)companyId lineCode:(NSString *)code reviewContent:(NSString *)content success:(SuccessBlock)success fail:(FailBlock)fail;

//新增评论 - LXB52246 - 已登录
+ (void)postReviewWithCompanyIdA:(NSNumber *)companyIdA staffIdA:(NSNumber *)staffIdA companyId:(NSNumber *)companyId lineCode:(NSString *)code reviewContent:(NSString *)content success:(SuccessBlock)success fail:(FailBlock)fail;

// 添加到我的微店 - LXB1224
+ (void)addToMyShopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 锁定微店 - LXB13244
+ (void)lockMicroshopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail;

// 专线/地接 - 未登录 - LXB2119
+ (void)getSuppliersListWithStartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 专线/地接 - 已登录 - LXB21210
+ (void)getSuppliersListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId StartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 供应商详情 - 未登录 - LXB21115
+ (void)getSupplierDetailWithSupplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSString *)isMy lineClass:(NSString *)lineClass lineType:(NSString *)lineType success:(SuccessBlock)success fail:(FailBlock)fail;

// 供应商详情 - 已登录 - LXB21216
+ (void)getSupplierDetailWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId supplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSString *)isMy lineClass:(NSString *)lineClass lineType:(NSString *)lineType success:(SuccessBlock)success fail:(FailBlock)fail;

// 我的供应商 - LXB21218
+ (void)getMySuppliersWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId lineClass:(NSString *)lineClass success:(SuccessBlock)success fail:(FailBlock)fail;

// 筛选供应商 - LXB21111
+ (void)getSiftedSuppliersWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 同步/取消同步供应商 - LXB22217 - type:0同步，1取消
+ (void)syncOrCancelSyncMySupplierWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId supplierId:(NSNumber *)supplierId supplierName:(NSString *)supplierName supplierBrand:(NSString *)supplierBrand type:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;

// 当地热门搜索列表 - LXB21112
+ (void)getHotSearchListWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 关键字搜索列表页 - LXB21113 - 未登录
+ (void)searchSupplierListWithStartCity:(NSString *)startCity lineClass:(NSString *)lineClass hotTheme:(NSString *)hotTheme keyword:(NSString *)keyword walkType:(NSString *)walkType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 关键字搜索列表页 - LXB21249 - 已登录
+ (void)searchSupplierListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId startCity:(NSString *)startCity lineClass:(NSString *)lineClass hotTheme:(NSString *)hotTheme keyword:(NSString *)keyword walkType:(NSString *)walkType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 服务商列表 - LXB31119 - 未登录
+ (void)getServiceListWithCounty:(NSString *)country province:(NSString *)province city:(NSString *)city pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 服务商列表 - LXB31220 - 已登录
+ (void)getServiceListWithWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId county:(NSString *)country province:(NSString *)province city:(NSString *)city pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 服务商详情 - LXB31121
+ (void)getServiceDetailWithServiceId:(NSNumber *)serviceId success:(SuccessBlock)success fail:(FailBlock)fail;

// 我的订单列表 - LXB41231 - 订单状态：0：未确认 1：已确认 2：已取消
+ (void)getMyOrderListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId status:(NSString *)status pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail;

// 取消/修改订单 - LXB43232
+ (void)modifyOrCancelMyOrderWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId orderId:(NSNumber *)orderId startDate:(NSString *)startDate returnDate:(NSString *)returnDate priceGroup:(NSString *)priceGroup contactPerson:(NSString *)person contactPhoneNo:(NSString *)phone touristGroup:(NSString *)touristGroup totalPrice:(NSString *)price status:(NSString *)status success:(SuccessBlock)success fail:(FailBlock)fail;

// 获取国家 - LXB51139
+ (void)getCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取省份 - LXB51140
+ (void)getProvincesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取城市 - LXB51141(所有国内外城市，暂时不用)
//+ (void)getCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取定位城市 - LXB51155
+ (void)getCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;


// 获取热门城市 - LXB51142
+ (void)getHotCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 获取热门国家 - LXB51143
+ (void)getHotCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail;

// 设置个人信息 - LXB43224
+ (void)setSelfInfoWithStaffId:(NSNumber *)staffId companyId:(NSNumber *)companyId avatarString:(NSString *)avatar contactName:(NSString *)contactName shopName:(NSString *)shopName phoneNumber:(NSString *)phoneNumber provinceId:(NSString *)provinceId provinceName:(NSString *)provinceName cityId:(NSString *)cityId cityName:(NSString *)cityName areaId:(NSString *)areaId areaName:(NSString *)areaName address:(NSString *)address success:(SuccessBlock)success fail:(FailBlock)fail;

// 验证邀请码 - LXB51164
+ (void)checkInvitationCodeWithInvitationCode:(NSString *)code success:(SuccessBlock)success fail:(FailBlock)fail;









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
