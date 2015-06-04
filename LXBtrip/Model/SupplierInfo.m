//
//  SupplierInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierInfo.h"

@implementation SupplierInfo

- (id)initWithDict:(NSDictionary *)dict
{
    self.supplierId = [dict[@"company_id"] isKindOfClass:[NSNull class]]?nil:dict[@"company_id"];
    self.supplierName = [dict[@"company_brand"] isKindOfClass:[NSNull class]]?nil:dict[@"company_brand"];
    self.supplierIsMy = [dict[@"is_my"] isKindOfClass:[NSNull class]]?nil:dict[@"is_my"];
    self.supplierIsNew = [dict[@"is_new"] isKindOfClass:[NSNull class]]?nil:dict[@"is_new"];
    self.supplierIsSync = [dict[@"is_sync"] isKindOfClass:[NSNull class]]?nil:dict[@"is_sync"];
    
    self.supplierLogo = [dict[@"company_logo"] isKindOfClass:[NSNull class]]?nil:dict[@"company_logo"];
    self.supplierLineType = [dict[@"line_type"] isKindOfClass:[NSNull class]]?nil:dict[@"line_type"];
    self.supplierLineTypeLetter = [dict[@"line_type_letter"] isKindOfClass:[NSNull class]]?nil:dict[@"line_type_letter"];

    
    NSArray *temp = [dict[@"goods_line_list"] isKindOfClass:[NSNull class]]?nil:dict[@"goods_line_list"];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
        [temp2 addObject:product];
    }];
    
    self.supplierProductsArray = [temp2 copy];
    
    return self;
}

@end
