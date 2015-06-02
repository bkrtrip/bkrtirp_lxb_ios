//
//  TourInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourInfo.h"

@implementation TourInfo

- (id)initWithDict:(NSDictionary *)dict
{
    // online shop common part - whether login or not
    self.tourImage = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.tourName = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.tourKeywords = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.tourCost = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];

    
    return self;
}


@end
