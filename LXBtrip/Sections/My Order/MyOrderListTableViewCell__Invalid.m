//
//  MyOrderListTableViewCell__Invalid.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderListTableViewCell__Invalid.h"

@interface MyOrderListTableViewCell__Invalid()

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;


@end

@implementation MyOrderListTableViewCell__Invalid

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    _timeLabel.text = item.orderStartDate;
    _contactNameLabel.text = item.orderContactName;
    _orderNameLabel.text = item.orderTravelGoodsName;
    
    float adultTotalPrice = [item.orderReservePriceGroup.adultNum integerValue]*[item.orderReservePriceGroup.adultPrice floatValue];
    
    float kidTotalPrice = [item.orderReservePriceGroup.kidNum integerValue]*[item.orderReservePriceGroup.kidPrice floatValue] +
    [item.orderReservePriceGroup.kidBedNum integerValue]*[item.orderReservePriceGroup.kidBedPrice floatValue];
    
    _adultPriceLabel.text = [NSString stringWithFormat:@"%@ * %@", item.orderReservePriceGroup.adultNum, item.orderReservePriceGroup.adultPrice];
    _childPriceLabel.text = [NSString stringWithFormat:@"%f", kidTotalPrice];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"%f", adultTotalPrice + kidTotalPrice];
}

- (IBAction)callButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall_Invalid)]) {
        [self.delegate supportClickWithPhoneCall_Invalid];
    }
}

@end
