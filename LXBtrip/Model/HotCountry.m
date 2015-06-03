//
//  HotCountry.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/3.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "HotCountry.h"

@implementation HotCountry

- (id)initWithDict:(NSDictionary *)dict
{
    self.hotCountryKey = [dict[@"key"] isKindOfClass:[NSNull class]]?nil:dict[@"key"];
    self.hotCountryValue = [dict[@"value"] isKindOfClass:[NSNull class]]?nil:dict[@"value"];
    
    return self;
}



@end
