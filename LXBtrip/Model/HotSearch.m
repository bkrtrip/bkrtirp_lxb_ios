//
//  HotSearch.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "HotSearch.h"

@implementation HotSearch

- (id)initWithDict:(NSDictionary *)dict
{
    self.hotSearchKey = [dict[@"key"] isKindOfClass:[NSNull class]]?nil:dict[@"key"];
    self.hotSearchValue = [dict[@"value"] isKindOfClass:[NSNull class]]?nil:dict[@"value"];
    
    return self;
}


@end
