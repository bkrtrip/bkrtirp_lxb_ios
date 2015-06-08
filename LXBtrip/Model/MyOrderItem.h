//
//  MyOrderItem.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReservePriceGroup.h"
#import "TouristInfo.h"

@interface MyOrderItem : NSObject

@property (nonatomic, copy) NSNumber *orderId;//
@property (nonatomic, copy) NSString *orderTravelGoodsCode;//
@property (nonatomic, copy) NSString *orderTravelGoodsName;//
@property (nonatomic, copy) NSString *orderStartCity;//

@property (nonatomic, copy) NSString *orderJourneyDays;//
@property (nonatomic, copy) NSString *orderStartDate;//
@property (nonatomic, copy) NSString *orderReturnDate;//

@property (nonatomic, strong) ReservePriceGroup *orderReservePriceGroup;
@property (nonatomic, strong) NSMutableArray *orderTouristGroup;

@property (nonatomic, copy) NSString *orderContactName;//
@property (nonatomic, copy) NSString *orderContactPhone;//
@property (nonatomic, copy) NSString *orderDealPrice;//
@property (nonatomic, copy) NSString *orderStatus;//

- (id)initWithDict:(NSDictionary *)dict;


@end
