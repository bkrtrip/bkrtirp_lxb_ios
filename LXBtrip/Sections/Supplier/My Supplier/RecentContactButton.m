//
//  RecentContactButton.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "RecentContactButton.h"

@interface RecentContactButton()

@property (strong, nonatomic) IBOutlet UILabel *supplierNameLable;
@property (strong, nonatomic) IBOutlet UILabel *lineClassLabel;

@end

@implementation RecentContactButton

- (void)setRecentContactButtonWithSupplierName:(NSString *)name lineClass:(NSString *)lineClass
{
    _supplierNameLable.text = name;
    _lineClassLabel.text = lineClass;
}

@end
