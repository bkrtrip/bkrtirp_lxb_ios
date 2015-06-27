//
//  MarketPriceLabel.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface MarketPriceLabel : UIView

- (void)setMarketPriceLabelWithPriceType:(TouristType)type price:(NSString *)price;

@end
