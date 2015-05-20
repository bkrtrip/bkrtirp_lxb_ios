//
//  MicroShopCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/20.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopCollectionViewCell.h"

@interface MicroShopCollectionViewCell()

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UIImageView *usedImageView;


@end

@implementation MicroShopCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _usedImageView.hidden = YES;
}

- (void)setCellContentWithMainImageView:(NSString *)main used:(BOOL)used shopName:(NSString *)shopName providerName:(NSString *)providerName
{
    _shopNameLabel.text = shopName;
    _providerNameLabel.text = providerName;
    
}




@end
