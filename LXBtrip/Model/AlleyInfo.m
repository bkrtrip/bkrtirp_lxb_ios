//
//  AlleyInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyInfo.h"

@implementation AlleyInfo

- (id)initWithDict:(NSDictionary *)dict
{
    self.alleyId = [dict[@"company_id"] isKindOfClass:[NSNull class]]?nil:dict[@"company_id"];
    self.alleyName = [dict[@"company_name"] isKindOfClass:[NSNull class]]?nil:dict[@"company_name"];

    self.alleyLogo = [dict[@"company_logo"] isKindOfClass:[NSNull class]]?nil:dict[@"company_logo"];
    
    self.alleyBrand = [dict[@"company_brand"] isKindOfClass:[NSNull class]]?nil:dict[@"company_brand"];
    self.alleyServiceNotice = [dict[@"service_notice"] isKindOfClass:[NSNull class]]?nil:dict[@"service_notice"];
    self.alleyContactPhoneNo = [dict[@"company_contactcallphone"] isKindOfClass:[NSNull class]]?nil:dict[@"company_contactcallphone"];



    self.alleyServiceCost = [dict[@"service_cost"] isKindOfClass:[NSNull class]]?nil:dict[@"service_cost"];
    self.alleyLocation = [dict[@"company_coordinate"] isKindOfClass:[NSNull class]]?nil:dict[@"company_coordinate"];
    self.alleyServiceCreateDate = [dict[@"company_createdate"] isKindOfClass:[NSNull class]]?nil:dict[@"company_createdate"];
    self.alleyJoinNum = [dict[@"join_num"] isKindOfClass:[NSNull class]]?nil:dict[@"join_num"];
    self.alleyJoinStatus = [dict[@"join_status"] isKindOfClass:[NSNull class]]?nil:dict[@"join_status"];
    
    self.alleyCompanyAddress = [dict[@"company_address"] isKindOfClass:[NSNull class]]?nil:dict[@"company_address"];
    
    id template = [dict[@"company_template"] isKindOfClass:[NSNull class]]?nil:dict[@"company_template"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (template && [template isKindOfClass:[NSArray class]]) {
        [template enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CompanyTemplate *template = [[CompanyTemplate alloc] initWithDict:obj];
            [temp addObject:template];
        }];
    }
    self.alleyCompanyTemplates = [temp copy];
    
    return self;
}


@end
