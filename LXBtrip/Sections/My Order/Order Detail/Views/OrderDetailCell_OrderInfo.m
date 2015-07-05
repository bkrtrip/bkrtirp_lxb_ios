//
//  OrderDetailCell_OrderInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "OrderDetailCell_OrderInfo.h"

@interface OrderDetailCell_OrderInfo()

@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *startCityLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *peopleNumLabel;

@end
@implementation OrderDetailCell_OrderInfo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    OrderListType type = [item.orderStatus intValue];
    switch (type) {
        case Order_Confirmed:
            _orderStatusLabel.text = @"已确认";
            break;
        case Order_Not_Confirm:
            _orderStatusLabel.text = @"未确认";
            break;
        case Order_Invalid:
            _orderStatusLabel.text = @"已失效";
            break;
        default:
            break;
    }
    
    _orderNoLabel.text = item.orderLineNo;
    _startCityLabel.text = item.orderStartCity;
    
    _startDateLabel.text = item.orderStartDate;
    _returnDateLabel.text = item.orderReturnDate;
    
    
    _peopleNumLabel.text = @"";

    if ([item.orderReservePriceGroup.adultNum integerValue] > 0) {
        _peopleNumLabel.text = [_peopleNumLabel.text stringByAppendingString:[NSString stringWithFormat:@"成人%@人", item.orderReservePriceGroup.adultNum]];
    }
    
    if ([item.orderReservePriceGroup.kidBedNum integerValue] > 0) {
        _peopleNumLabel.text = [_peopleNumLabel.text stringByAppendingString:[NSString stringWithFormat:@", 儿童/占床%@人", item.orderReservePriceGroup.kidBedNum]];
    }
    
    if ([item.orderReservePriceGroup.kidNum integerValue] > 0) {
        _peopleNumLabel.text = [_peopleNumLabel.text stringByAppendingString:[NSString stringWithFormat:@", 儿童%@人", item.orderReservePriceGroup.kidNum]];
    }
}






@end
