//
//  Province.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "Province.h"

@implementation Province

- (id)initWithDict:(NSDictionary *)dict
{
    self.provinceId = [dict[@"province_id"] isKindOfClass:[NSNull class]]?nil:dict[@"province_id"];
    self.countryId = [dict[@"country_id"] isKindOfClass:[NSNull class]]?nil:dict[@"country_id"];

    self.provinceName = [dict[@"province_name"] isKindOfClass:[NSNull class]]?nil:dict[@"province_name"];
    
    self.provincePinYin = [dict[@"pinyin"] isKindOfClass:[NSNull class]]?nil:dict[@"pinyin"];
    self.provinceAcronym = [dict[@"acronym_word"] isKindOfClass:[NSNull class]]?nil:dict[@"acronym_word"];
    self.provinceInitail = [dict[@"initial"] isKindOfClass:[NSNull class]]?nil:dict[@"initial"];
    self.provinceAreaFlag = [dict[@"area_flag"] isKindOfClass:[NSNull class]]?nil:dict[@"area_flag"];
    
    return self;
}


@end
