//
//  CreateOrderCell_OrderId.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_OrderId.h"

@interface CreateOrderCell_OrderId()
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;

@end

@implementation CreateOrderCell_OrderId

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号: %@", item.orderId];
    _orderNameLabel.text = item.orderTravelGoodsName;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
