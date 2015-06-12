//
//  SupplierInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierProduct.h"

@interface SupplierInfo : NSObject

@property (nonatomic, copy) NSString *supplierName;
@property (nonatomic, copy) NSNumber *supplierId;
@property (nonatomic, copy) NSString *supplierBrand;
@property (nonatomic, copy) NSString *supplierLogo;
@property (nonatomic, copy) NSString *supplierLineType;
@property (nonatomic, copy) NSString *supplierLineTypeLetter;

@property (nonatomic, copy) NSString *supplierContactPhone;


@property (nonatomic, copy) NSMutableArray *supplierProductsArray; // contains SupplierProduct

@property (nonatomic, copy) NSNumber *supplierIsMy;
@property (nonatomic, copy) NSNumber *supplierIsNew;
@property (nonatomic, copy) NSNumber *supplierIsSync;

// for TourList page
@property (nonatomic, copy) NSString *supplierEndCity;//目的城市 多个用#隔开  （搜索条件）
@property (nonatomic, copy) NSString *supplierCustomName;//分类名称 （页面标题）
@property (nonatomic, copy) NSNumber *supplierCustomId;//分类id



- (id)initWithDict:(NSDictionary *)dict;

@end
