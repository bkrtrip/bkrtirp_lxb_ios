//
//  HotCity.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "HotCity.h"

@implementation HotCity

- (id)initWithDict:(NSDictionary *)dict
{
    self.hotCityKey = [dict[@"key"] isKindOfClass:[NSNull class]]?nil:dict[@"key"];
    self.hotCityValue = [dict[@"value"] isKindOfClass:[NSNull class]]?nil:dict[@"value"];
    
    return self;
}


@end
