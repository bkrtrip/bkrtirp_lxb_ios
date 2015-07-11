//
//  CreateOrderCell_Price.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_Price.h"

@interface CreateOrderCell_Price()
{
    TouristType touristType;
    MyOrderItem *yOrder;
}

@property (strong, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UILabel *personNumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *separatorHorImageView;

@property (strong, nonatomic) IBOutlet UIView *graySeparatorView;
@property (strong, nonatomic) IBOutlet UILabel *diffPriceLabel;
@end

@implementation CreateOrderCell_Price

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithOrder:(MyOrderItem *)order touristType:(TouristType)type shouldShowGraySeparator:(BOOL)showSeparator
{
    touristType = type;
    
    switch (type) {
        case Adult:
        {
            _priceTitleLabel.text = @"成人价：";
            _priceLabel.text = [@"￥" stringByAppendingString:order.orderReservePriceGroup.adultPrice];
            
            if (!order.orderReservePriceGroup.adultNum || order.orderReservePriceGroup.adultNum.length == 0) {
                _personNumLabel.text = @"￥0";
            } else {
                _personNumLabel.text = order.orderReservePriceGroup.adultNum;
            }
            _diffPriceLabel.hidden = YES;
        }
            break;
        case Kid_Bed:
        {
            _priceTitleLabel.text = @"儿童价：";
            _priceLabel.text = [NSString stringWithFormat:@"￥%@/占床", order.orderReservePriceGroup.kidBedPrice];
            
            if (!order.orderReservePriceGroup.kidBedNum || order.orderReservePriceGroup.kidBedNum.length == 0) {
                _personNumLabel.text = @"0";
            } else {
                _personNumLabel.text = order.orderReservePriceGroup.kidBedNum;
            }
            _diffPriceLabel.hidden = YES;
        }
            break;
        case Kid_No_Bed:
        {
            _priceTitleLabel.text = @"儿童价：";
            _priceLabel.text = [@"￥" stringByAppendingString:order.orderReservePriceGroup.kidPrice];
            if (!order.orderReservePriceGroup.kidNum || order.orderReservePriceGroup.kidNum.length == 0) {
                _personNumLabel.text = @"0";
            } else {
                _personNumLabel.text = order.orderReservePriceGroup.kidNum;
            }
            _diffPriceLabel.hidden = NO;
            _diffPriceLabel.text = [NSString stringWithFormat:@"单房差：￥%@（成人数为单数时需补足双人间房费）", order.orderReservePriceGroup.diffPrice];
        }
            break;
        default:
            break;
    }
    
    // adjust display style if Num == 0
    if ([_personNumLabel.text isEqualToString:@"0"]) {
        _minusButton.enabled = NO;
        _personNumLabel.backgroundColor = [UIColor whiteColor];
        _personNumLabel.textColor = TEXT_333333;
    } else {
        _minusButton.enabled = YES;
        _personNumLabel.backgroundColor = RED_FF0075;
        _personNumLabel.textColor = [UIColor whiteColor];
    }
    
    _graySeparatorView.hidden = !showSeparator;
    _separatorHorImageView.hidden = showSeparator;
}

- (IBAction)minusButtonClicked:(id)sender {
    _personNumLabel.text = [@([_personNumLabel.text integerValue]-1) stringValue];
    // adjust display style if Num == 0
    if ([_personNumLabel.text isEqualToString:@"0"]) {
        _minusButton.enabled = NO;
        _personNumLabel.backgroundColor = [UIColor whiteColor];
        _personNumLabel.textColor = TEXT_333333;
    } else {
        _minusButton.enabled = YES;
        _personNumLabel.backgroundColor = RED_FF0075;
        _personNumLabel.textColor = [UIColor whiteColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(supportClickPlusOrMinusWithDeltaNum:touristType:)]) {
        [self.delegate supportClickPlusOrMinusWithDeltaNum:-1 touristType:touristType];
    }
}
- (IBAction)plusButtonClicked:(id)sender {
    _personNumLabel.textColor = [UIColor whiteColor];
    _personNumLabel.text = [@([_personNumLabel.text integerValue]+1) stringValue];
    
    if (_minusButton.enabled == NO) {
        _minusButton.enabled = YES;
        _personNumLabel.backgroundColor = RED_FF0075;
    }
    
    if ([self.delegate respondsToSelector:@selector(supportClickPlusOrMinusWithDeltaNum:touristType:)]) {
        [self.delegate supportClickPlusOrMinusWithDeltaNum:+1 touristType:touristType];
    }
}

@end
