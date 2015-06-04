//
//  SupplierInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierProduct.h"

@interface SupplierInfo : NSObject

@property (nonatomic, copy) NSString *supplierName;
@property (nonatomic, copy) NSNumber *supplierId;
@property (nonatomic, copy) NSString *supplierBrand;
@property (nonatomic, copy) NSString *supplierLogo;
@property (nonatomic, copy) NSString *supplierLineType;
@property (nonatomic, copy) NSString *supplierLineTypeLetter;


@property (nonatomic, copy) NSMutableArray *supplierProductsArray; // contains SupplierProduct

@property (nonatomic, copy) NSNumber *supplierIsMy;
@property (nonatomic, copy) NSNumber *supplierIsNew;
@property (nonatomic, copy) NSNumber *supplierIsSync;

- (id)initWithDict:(NSDictionary *)dict;

@end
