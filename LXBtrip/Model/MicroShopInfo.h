//
//  MicroShopInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroShopInfo : NSObject

@property (nonatomic, copy) NSNumber *shopId;
@property (nonatomic, copy) NSNumber *shopNo;

@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopProvider;
@property (nonatomic, copy) NSString *shopImg;
@property (nonatomic, copy) NSNumber *shopOrderNum;
@property (nonatomic, copy) NSNumber *shopUsageAmount;
@property (nonatomic, copy) NSNumber *shopIsUse;//是否使用 0：使用，1：未使用

@property (nonatomic, copy) NSNumber *shopGoodsNum;
@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, copy) NSString *shopIntroduction;
@property (nonatomic, copy) NSString *shopPreviewURLString;
@property (nonatomic, copy) NSNumber *shopIsLock;//是否锁定 0：可锁定，1：不可锁定
@property (nonatomic, copy) NSNumber *shopIsDefault;//是否默认 0：默认，1：其它 （我的微店只有一套是默认的）


- (id)initWithDict:(NSDictionary *)dict;

@end
