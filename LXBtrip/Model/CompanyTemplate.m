//
//  CompanyTemplate.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CompanyTemplate.h"

@implementation CompanyTemplate


- (id)initWithDict:(NSDictionary *)dict
{
    self.templateImgURL = [dict[@"template_img_url"] isKindOfClass:[NSNull class]]?nil:dict[@"template_img_url"];
    self.templateHttpURL = [dict[@"template_url"] isKindOfClass:[NSNull class]]?nil:dict[@"template_url"];
    
    return self;
}

@end
