//
//  ReusableHeaderView_SiftSupplier.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/5.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "ReusableHeaderView_SiftSupplier.h"

@interface ReusableHeaderView_SiftSupplier()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headerNameLabels;

@end

@implementation ReusableHeaderView_SiftSupplier

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSiftSupplierReusableHeaderWithHeaderNames:(NSArray *)names
{
    [_headerNameLabels enumerateObjectsUsingBlock:^(UILabel *lb, NSUInteger idx, BOOL *stop) {
        if (names.count > idx) {
            lb.text = names[idx];
        } else {
            lb.text = @"";
        }
    }];
}

@end
