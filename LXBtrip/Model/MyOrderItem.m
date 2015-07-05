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
    self.orderCompanyId = [dict[@"company_id"] isKindOfClass:[NSNull class]]?nil:dict[@"company_id"];
    self.orderStaffId = [dict[@"staff_id"] isKindOfClass:[NSNull class]]?nil:dict[@"staff_id"];
    self.orderContactName = [dict[@"contacts_name"] isKindOfClass:[NSNull class]]?nil:dict[@"contacts_name"];
    self.orderContactPhone = [dict[@"contacts_phone"] isKindOfClass:[NSNull class]]?nil:dict[@"contacts_phone"];
    self.orderJourneyDays = [dict[@"journey_day"] isKindOfClass:[NSNull class]]?nil:dict[@"journey_day"];
    self.orderLineCode = [dict[@"line_order_code"] isKindOfClass:[NSNull class]]?nil:dict[@"line_order_code"];
    self.orderLineId = [dict[@"line_order_id"] isKindOfClass:[NSNull class]]?nil:dict[@"line_order_id"];
    self.orderLineNo = [dict[@"line_order_no"] isKindOfClass:[NSNull class]]?nil:dict[@"line_order_no"];
    self.orderDealPrice = [dict[@"make_price"] isKindOfClass:[NSNull class]]?nil:dict[@"make_price"];
    self.orderStatus = [dict[@"order_status"] isKindOfClass:[NSNull class]]?nil:dict[@"order_status"];

    // reserve_price_group
    NSString *temp = [dict[@"reserve_price_group"] isKindOfClass:[NSNull class]]?nil:dict[@"reserve_price_group"];
    id tempObject = [self arrayOrDictinaryWithJsonString:temp];
    self.orderReservePriceGroup = [[ReservePriceGroup alloc] initWithDict:tempObject];
    
    // tourist_group
    temp = [dict[@"tourist_group"] isKindOfClass:[NSNull class]]?nil:dict[@"tourist_group"];
    id tempDict = [self arrayOrDictinaryWithJsonString:temp];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if ([tempDict isKindOfClass:[NSArray class]]) {
        [tempDict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                TouristInfo *touristInfo = [[TouristInfo alloc] initWithDict:obj];
                [tempArray addObject:touristInfo];
            }
        }];
    }
    self.orderTouristGroup = [tempArray mutableCopy];
    
    self.orderTravelGoodsCode = [dict[@"travel_goods_code"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_code"];
    self.orderTravelGoodsId = [dict[@"travel_goods_id"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_id"];
    self.orderTravelGoodsName = [dict[@"travel_goods_name"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_name"];
    self.orderTravelGoodsImg = [dict[@"travel_goods_img"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_goods_img"];

    self.orderStartCity = [dict[@"start_city"] isKindOfClass:[NSNull class]]?nil:dict[@"start_city"];

    self.orderStartDate = [dict[@"start_date"] isKindOfClass:[NSNull class]]?nil:dict[@"start_date"];
    self.orderReturnDate = [dict[@"return_date"] isKindOfClass:[NSNull class]]?nil:dict[@"return_date"];
    
    return self;
}

#pragma mark - Private methods
- (id)arrayOrDictinaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if (data) {
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return obj;
    }
    return nil;
}


@end
