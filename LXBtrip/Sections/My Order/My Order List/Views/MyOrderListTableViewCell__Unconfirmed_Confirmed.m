//
//  MyOrderListTableViewCell__Unconfirmed_Confirmed.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderListTableViewCell__Unconfirmed_Confirmed.h"

@interface MyOrderListTableViewCell__Unconfirmed_Confirmed()
{
    MyOrderItem *order;
}

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *orderImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *cancelOrderButton;
- (IBAction)cancelOrderButtonClicked:(id)sender;
@end

@implementation MyOrderListTableViewCell__Unconfirmed_Confirmed

- (void)awakeFromNib {
    // Initialization code
    _cancelOrderButton.layer.cornerRadius = 3.f;
}

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item
{
    order = item;
    
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, item.orderTravelGoodsImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    _timeLabel.text = [NSString stringWithFormat:@"团期:%@", item.orderStartDate];
    _contactNameLabel.text = item.orderContactName;
    _orderNameLabel.text = item.orderTravelGoodsName;
    
    float adultTotalPrice = [item.orderReservePriceGroup.adultNum integerValue]*[item.orderReservePriceGroup.adultPrice floatValue];
    
    float kidTotalPrice = [item.orderReservePriceGroup.kidNum integerValue]*[item.orderReservePriceGroup.kidPrice floatValue] +
    [item.orderReservePriceGroup.kidBedNum integerValue]*[item.orderReservePriceGroup.kidBedPrice floatValue];
    
    if (adultTotalPrice == 0) {
        _adultPriceLabel.text = @"成人:￥0.00";
    } else {
        _adultPriceLabel.text = [NSString stringWithFormat:@"成人:￥%@ * %.2f", item.orderReservePriceGroup.adultNum, [item.orderReservePriceGroup.adultPrice floatValue]];
    }
    
    _childPriceLabel.text = [NSString stringWithFormat:@"儿童:￥%.2f", kidTotalPrice];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", adultTotalPrice + kidTotalPrice];
}


- (IBAction)callButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickPhoneCallWithOrder:)]) {
        [self.delegate supportClickPhoneCallWithOrder:order];
    }
}

- (IBAction)cancelOrderButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickCancelOrderWithOrder:)]) {
        [self.delegate supportClickCancelOrderWithOrder:order];
    }
}
@end
