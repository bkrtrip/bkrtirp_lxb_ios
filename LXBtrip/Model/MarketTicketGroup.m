//
//  MarketTicketGroup.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MarketTicketGroup.h"

@implementation MarketTicketGroup

- (id)initWithDict:(NSDictionary *)dict
{
    self.marketAdultPerson = [dict[@"market_adult_person"] isKindOfClass:[NSNull class]]?nil:dict[@"market_adult_person"];
    self.marketAdultPrice = [dict[@"market_adult_price"] isKindOfClass:[NSNull class]]?nil:dict[@"market_adult_price"];
    
    self.marketKidPerson = [dict[@"market_kid_person"] isKindOfClass:[NSNull class]]?nil:dict[@"market_kid_person"];
    self.marketKidPrice = [dict[@"market_kid_price"] isKindOfClass:[NSNull class]]?nil:dict[@"market_kid_price"];
    self.marketKidPriceNoBed = [dict[@"market_kid_price_nbed"] isKindOfClass:[NSNull class]]?nil:dict[@"market_kid_price_nbed"];

    self.marketDiffPrice = [dict[@"market_diff_price"] isKindOfClass:[NSNull class]]?nil:dict[@"market_diff_price"];
    self.marketTime = [dict[@"market_time"] isKindOfClass:[NSNull class]]?nil:dict[@"market_time"];

    return self;
}

@end
