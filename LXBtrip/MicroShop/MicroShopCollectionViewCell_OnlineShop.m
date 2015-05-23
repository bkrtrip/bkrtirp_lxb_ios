//
//  MicroShopCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/20.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopCollectionViewCell_OnlineShop.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppMacro.h"

@interface MicroShopCollectionViewCell_OnlineShop()

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UIImageView *usedImageView;


@end

@implementation MicroShopCollectionViewCell_OnlineShop

- (void)awakeFromNib {
    // Initialization code
    _usedImageView.hidden = YES;
    _shopNameLabel.text = nil;
    _providerNameLabel.text = nil;
    _mainImageView.image = nil;
}

- (void)setCellContentWithMicroShopInfo:(MicroShopInfo *)info
{
    _shopNameLabel.text = info.shopName;
    _providerNameLabel.text = info.shopCompanyName;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.shopImg]] placeholderImage:nil options:SDWebImageProgressiveDownload];
}

@end
