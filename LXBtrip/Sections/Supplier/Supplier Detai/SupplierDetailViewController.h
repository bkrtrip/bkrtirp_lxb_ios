//
//  SupplierDetailViewController.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "NavBaseViewController.h"

@interface SupplierDetailViewController : NavBaseViewController

@property (nonatomic, strong) SupplierInfo *info;
@property (nonatomic, copy) NSString *lineClass;
@property (nonatomic, copy) NSString *lineType;

@end
