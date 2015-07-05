//
//  TouristGroup.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TouristInfo.h"

@implementation TouristInfo

- (id)initWithDict:(NSDictionary *)dict
{
//    self.touristCode = [dict[@"tourist_code"] isKindOfClass:[NSNull class]]?nil:dict[@"tourist_code"];
//    self.touristName = [dict[@"tourist_name"] isKindOfClass:[NSNull class]]?nil:dict[@"tourist_name"];
    
    self.touristCode = [dict[@"cred"] isKindOfClass:[NSNull class]]?nil:dict[@"cred"];
    self.touristName = [dict[@"user"] isKindOfClass:[NSNull class]]?nil:dict[@"user"];
    
//    self.userId = [dict[@"user"] isKindOfClass:[NSNull class]]?nil:dict[@"user"];
//    self.userCredit = [dict[@"cred"] isKindOfClass:[NSNull class]]?nil:dict[@"cred"];
    
    return self;
}

@end
