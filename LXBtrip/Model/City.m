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
    self.cityName = [dict[@"name"] isKindOfClass:[NSNull class]]?nil:dict[@"name"];
    self.cityPinYin = [dict[@"pinyin"] isKindOfClass:[NSNull class]]?nil:dict[@"pinyin"];
    self.cityAcronym = [dict[@"acronym_word"] isKindOfClass:[NSNull class]]?nil:dict[@"acronym_word"];
    self.cityInitail = [dict[@"initial"] isKindOfClass:[NSNull class]]?nil:dict[@"initial"];

    return self;
}




@end
