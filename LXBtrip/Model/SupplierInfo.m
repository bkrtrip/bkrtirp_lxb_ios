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
    self.supplierName = [dict[@"company_name"] isKindOfClass:[NSNull class]]?nil:dict[@"company_name"];
    self.supplierBrand = [dict[@"company_brand"] isKindOfClass:[NSNull class]]?nil:dict[@"company_brand"];
    self.supplierLogo = [dict[@"company_logo"] isKindOfClass:[NSNull class]]?nil:dict[@"company_logo"];
    
    self.supplierContactPhone = [dict[@"company_contactcallphone"] isKindOfClass:[NSNull class]]?nil:dict[@"company_contactcallphone"];


    self.supplierIsSync = [dict[@"is_sync"] isKindOfClass:[NSNull class]]?nil:dict[@"is_sync"];
    
    // for supplierDetail page
    NSArray *temp = [dict[@"goods_line_list"] isKindOfClass:[NSNull class]]?nil:dict[@"goods_line_list"];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
        [temp2 addObject:product];
    }];
    self.supplierProductsArray = [temp2 copy];
    
    if (self.supplierProductsArray.count == 0) {
        // for TourList page
        NSArray *temp = [dict[@"line_list"] isKindOfClass:[NSNull class]]?nil:dict[@"line_list"];
        NSMutableArray *temp2 = [[NSMutableArray alloc] init];
        [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SupplierProduct *product = [[SupplierProduct alloc] initWithDict:obj];
            [temp2 addObject:product];
        }];
        self.supplierProductsArray = [temp2 copy];
    }
    
    


    self.supplierIsMy = [dict[@"is_my"] isKindOfClass:[NSNull class]]?nil:dict[@"is_my"];
    self.supplierIsNew = [dict[@"is_new"] isKindOfClass:[NSNull class]]?nil:dict[@"is_new"];
    
    self.supplierLineType = [dict[@"line_type"] isKindOfClass:[NSNull class]]?nil:dict[@"line_type"];
    self.supplierLineTypeLetter = [dict[@"line_type_letter"] isKindOfClass:[NSNull class]]?nil:dict[@"line_type_letter"];

    // for TourList page
    self.supplierJourneyDay = [dict[@"journey_day"] isKindOfClass:[NSNull class]]?nil:dict[@"journey_day"];
    self.supplierInnerEndCity = [dict[@"inner_end_city"] isKindOfClass:[NSNull class]]?nil:dict[@"inner_end_city"];
    self.supplierOuterEndCity = [dict[@"out_end_city"] isKindOfClass:[NSNull class]]?nil:dict[@"out_end_city"];
    self.supplierCustomName = [dict[@"custom_name"] isKindOfClass:[NSNull class]]?nil:dict[@"custom_name"];
    self.supplierCustomId = [dict[@"custom_id"] isKindOfClass:[NSNull class]]?nil:dict[@"custom_id"];

    
    return self;
}

@end
