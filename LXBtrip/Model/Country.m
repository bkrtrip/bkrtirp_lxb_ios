//
//  Country.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "Country.h"

@implementation Country

- (id)initWithDict:(NSDictionary *)dict
{
    self.countryId = [dict[@"country_id"] isKindOfClass:[NSNull class]]?nil:dict[@"country_id"];
    self.countryName = [dict[@"country_name"] isKindOfClass:[NSNull class]]?nil:dict[@"country_name"];
    
    self.countryPinYin = [dict[@"pinyin"] isKindOfClass:[NSNull class]]?nil:dict[@"pinyin"];
    self.countryAcronym = [dict[@"acronym_word"] isKindOfClass:[NSNull class]]?nil:dict[@"acronym_word"];
    self.countryInitail = [dict[@"initial"] isKindOfClass:[NSNull class]]?nil:dict[@"initial"];
    self.countryAreaFlag = [dict[@"area_flag"] isKindOfClass:[NSNull class]]?nil:dict[@"area_flag"];
    
    return self;
}

@end
