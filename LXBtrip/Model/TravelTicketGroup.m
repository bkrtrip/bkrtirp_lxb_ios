//
//  TravelTicketGroup.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TravelTicketGroup.h"

@implementation TravelTicketGroup

- (id)initWithDict:(NSDictionary *)dict
{
    self.travelAdultPerson = [dict[@"travel_adult_person"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_adult_person"];
    self.travelAdultPrice = [dict[@"travel_adult_price"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_adult_price"];
    
    self.travelKidPerson = [dict[@"travel_kid_person"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_kid_person"];
    self.travelKidPrice = [dict[@"travel_kid_price"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_kid_price"];
    self.travelKidPriceNoBed = [dict[@"travel_kid_price_nbed"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_kid_price_nbed"];
    self.travelKidPersonNoBed = [dict[@"travel_kid_person_nbed"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_kid_person_nbed"];

    
    self.travelDiffPrice = [dict[@"travel_diff_price"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_diff_price"];
    self.travelTime = [dict[@"travel_time"] isKindOfClass:[NSNull class]]?nil:dict[@"travel_time"];
    
    return self;
}


@end
