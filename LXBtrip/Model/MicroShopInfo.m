//
//  MicroShopInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopInfo.h"

@implementation MicroShopInfo

- (id)initWithDict:(NSDictionary *)dict
{
    // online shop common part - whether login or not
    self.shopId = [dict[@"template_id"] isKindOfClass:[NSNull class]]?nil:dict[@"template_id"];
    self.shopNo = [dict[@"template_no"] isKindOfClass:[NSNull class]]?nil:dict[@"template_no"];
    self.shopName = [dict[@"template_name"] isKindOfClass:[NSNull class]]?nil:dict[@"template_name"];
    self.shopCompanyName = [dict[@"template_companyname"] isKindOfClass:[NSNull class]]?nil:dict[@"template_companyname"];
    self.shopImg = [dict[@"template_img"] isKindOfClass:[NSNull class]]?nil:dict[@"template_img"];
    self.shopOrderNum = [dict[@"order_num"] isKindOfClass:[NSNull class]]?nil:dict[@"order_num"];
    
    // online shop - after login exclusive
    self.shopUsageAmount = [dict[@"usage_amount"] isKindOfClass:[NSNull class]]?nil:dict[@"usage_amount"];
    self.shopIsUse = [dict[@"is_use"] isKindOfClass:[NSNull class]]?nil:dict[@"is_use"];
    
    // my shop exclusive
    self.shopGoodsNum = [dict[@"goods_num"] isKindOfClass:[NSNull class]]?nil:dict[@"goods_num"];
    self.shopType = [dict[@"template_type"] isKindOfClass:[NSNull class]]?nil:dict[@"template_type"];
    self.shopIntroduction = [dict[@"template_referral"] isKindOfClass:[NSNull class]]?nil:dict[@"template_referral"];
    self.shopPreviewURLString = [dict[@"template_url"] isKindOfClass:[NSNull class]]?nil:dict[@"template_url"];
    self.shopIsLock = [dict[@"is_lock"] isKindOfClass:[NSNull class]]?nil:dict[@"is_lock"];
    self.shopIsDefault = [dict[@"is_default"] isKindOfClass:[NSNull class]]?nil:dict[@"is_default"];


    return self;
}


@end
