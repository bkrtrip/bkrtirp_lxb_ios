//
//  MarketPriceLabel.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MarketPriceLabel.h"

@interface MarketPriceLabel()

@property (strong, nonatomic) IBOutlet UIImageView *marketImageView;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;

@end

@implementation MarketPriceLabel

- (void)setMarketPriceLabelWithPriceType:(TouristType)type price:(NSString *)price
{
    switch (type) {
        case Adult:
            _marketImageView.image = ImageNamed(@"adult_price_label");
            break;
        case Kid_Bed:
            _marketImageView.image = ImageNamed(@"kid_bed");
            break;
        case Kid_No_Bed:
            _marketImageView.image = ImageNamed(@"kid_no_bed");
            break;
        default:
            break;
    }
    _marketPriceLabel.text = [NSString stringWithFormat:@"￥%@", price];
}

@end
