//
//  City.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "City.h"

@implementation City

- (id)initWithDict:(NSDictionary *)dict
{
    self.cityId = [dict[@"city_id"] isKindOfClass:[NSNull class]]?nil:dict[@"city_id"];
    self.cityName = [dict[@"city_name"] isKindOfClass:[NSNull class]]?nil:dict[@"city_name"];
    self.provinceId = [dict[@"province_id"] isKindOfClass:[NSNull class]]?nil:dict[@"province_id"];
    self.countryId = [dict[@"country_id"] isKindOfClass:[NSNull class]]?nil:dict[@"country_id"];
    self.cityPinYin = [dict[@"pinyin"] isKindOfClass:[NSNull class]]?nil:dict[@"pinyin"];
    self.cityAcronym = [dict[@"acronym_word"] isKindOfClass:[NSNull class]]?nil:dict[@"acronym_word"];
    self.cityInitail = [dict[@"initial"] isKindOfClass:[NSNull class]]?nil:dict[@"initial"];

    return self;
}




@end
