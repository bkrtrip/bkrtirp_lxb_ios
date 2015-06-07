//
//  MyOrderItem.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderItem.h"

@implementation MyOrderItem


- (id)initWithDict:(NSDictionary *)dict
{
    self.orderId = [dict[@"line_order_id"] isKindOfClass:[NSNull class]]?nil:dict[@"line_order_id"];
    self.orderTravelGoodsCode = [dict[@"travel_goods_code"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_code"];
    
    self.orderTravelGoodsName = [dict[@"travel_goods_name"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_name"];
    self.orderStartDate = [dict[@"start_date"] isKindOfClass:[NSNull class]]?nil:dict[@"start_date"];
    self.orderReturnDate = [dict[@"return_date"] isKindOfClass:[NSNull class]]?nil:dict[@"return_date"];
    self.orderJourneyDays = [dict[@"journey_day"] isKindOfClass:[NSNull class]]?nil:dict[@"journey_day"];
    
    id reservePriceGroup = [dict[@"reserve_price_group"] isKindOfClass:[NSNull class]]?nil:dict[@"reserve_price_group"];
    if (reservePriceGroup) {
        self.orderReservePriceGroup = [[ReservePriceGroup alloc] initWithDict:reservePriceGroup];
    }
    
    id touristGroup = [dict[@"tourist_group"] isKindOfClass:[NSNull class]]?nil:dict[@"reserve_price_group"];
    if (reservePriceGroup) {
        self.orderTouristGroup = [[TouristGroup alloc] initWithDict:touristGroup];
    }
    
    self.orderContactName = [dict[@"contacts_name"] isKindOfClass:[NSNull class]]?nil:dict[@"contacts_name"];
    self.orderContactPhone = [dict[@"contacts_phone"] isKindOfClass:[NSNull class]]?nil:dict[@"contacts_phone"];
    self.orderDealPrice = [dict[@"make price"] isKindOfClass:[NSNull class]]?nil:dict[@"make price"];
    self.orderStatus = [dict[@"order_status"] isKindOfClass:[NSNull class]]?nil:dict[@"order_status"];
    
    return self;
}

@end
