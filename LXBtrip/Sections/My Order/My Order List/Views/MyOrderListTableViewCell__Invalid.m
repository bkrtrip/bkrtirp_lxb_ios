//
//  MyOrderListTableViewCell__Invalid.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyOrderListTableViewCell__Invalid.h"

@interface MyOrderListTableViewCell__Invalid()
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


@end

@implementation MyOrderListTableViewCell__Invalid

- (void)awakeFromNib {
    // Initialization code
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
    
    float kidNoBedPrict = [item.orderReservePriceGroup.kidNum integerValue]*[item.orderReservePriceGroup.kidPrice floatValue];
    
    float kidBedPrice = [item.orderReservePriceGroup.kidBedNum integerValue]*[item.orderReservePriceGroup.kidBedPrice floatValue];
    
    if (adultTotalPrice == 0) {
        _adultPriceLabel.hidden = YES;
    } else {
        _adultPriceLabel.hidden = NO;
        _adultPriceLabel.text = [NSString stringWithFormat:@"成人:￥%@*%.2f", item.orderReservePriceGroup.adultNum, [item.orderReservePriceGroup.adultPrice floatValue]];
    }
    
    if (kidNoBedPrict == 0) {
        if (kidBedPrice == 0) {
            _childPriceLabel.hidden = YES;
        } else {
            _childPriceLabel.hidden = NO;
            _childPriceLabel.text = [NSString stringWithFormat:@"儿童:￥%@*%.2f",item.orderReservePriceGroup.kidBedNum, [item.orderReservePriceGroup.kidBedPrice floatValue]];
        }
    } else {
        _childPriceLabel.hidden = NO;
        _childPriceLabel.text = [NSString stringWithFormat:@"儿童:￥%@*%.2f",item.orderReservePriceGroup.kidNum, [item.orderReservePriceGroup.kidPrice floatValue]];
    }
    
    if (item.orderDealPrice && [item.orderDealPrice floatValue] > 0) {
        _totalPriceLabel.hidden = NO;
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [item.orderDealPrice floatValue]];
    } else {
        _totalPriceLabel.hidden = YES;
    }
}

- (IBAction)callButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall_InvalidWithOrder:)]) {
        [self.delegate supportClickWithPhoneCall_InvalidWithOrder:order];
    }
}

@end
