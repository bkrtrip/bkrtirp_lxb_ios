//
//  MyOrderListTableViewCell__Unconfirmed_Confirmed.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderListTableViewCell__Unconfirmed_Confirmed.h"

@interface MyOrderListTableViewCell__Unconfirmed_Confirmed()

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

- (IBAction)cancelOrderButtonClicked:(id)sender;
@end

@implementation MyOrderListTableViewCell__Unconfirmed_Confirmed

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
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall)]) {
        [self.delegate supportClickWithPhoneCall];
    }
}

- (IBAction)cancelOrderButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithCancelOrder)]) {
        [self.delegate supportClickWithCancelOrder];
    }
}
@end
