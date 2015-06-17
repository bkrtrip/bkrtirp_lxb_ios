//
//  OrderDetailCell_ContactInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailCell_ContactInfo.h"

@interface OrderDetailCell_ContactInfo()

@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPhoneNumberLabel;


@end

@implementation OrderDetailCell_ContactInfo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    _contactNameLabel.text = item.orderContactName;
    _contactPhoneNumberLabel.text = item.orderContactPhone;
}


@end
