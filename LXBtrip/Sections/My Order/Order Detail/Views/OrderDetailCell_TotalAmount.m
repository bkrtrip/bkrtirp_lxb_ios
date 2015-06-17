//
//  OrderDetailCell_TotalAmount.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailCell_TotalAmount.h"

@interface OrderDetailCell_TotalAmount()

@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation OrderDetailCell_TotalAmount

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    float adultTotalPrice = [item.orderReservePriceGroup.adultNum integerValue]*[item.orderReservePriceGroup.adultPrice floatValue];
    
    float kidTotalPrice = [item.orderReservePriceGroup.kidNum integerValue]*[item.orderReservePriceGroup.kidPrice floatValue] +
    [item.orderReservePriceGroup.kidBedNum integerValue]*[item.orderReservePriceGroup.kidBedPrice floatValue];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", adultTotalPrice + kidTotalPrice];
}


@end
