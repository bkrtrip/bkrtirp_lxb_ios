//
//  MicroShopCollectionViewCell_MyShop.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopCollectionViewCell_MyShop.h"
#import "AppMacro.h"

@interface MicroShopCollectionViewCell_MyShop()
{
    TemplateDefaultStatus defaultStatus;
}

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UIButton *deleteOrLockButton;
- (IBAction)deleteOrLockButtonClicked:(id)sender;

@property (strong, nonatomic) MicroShopInfo *shopInfo;


@end

@implementation MicroShopCollectionViewCell_MyShop

- (void)awakeFromNib {
    _shopNameLabel.text = nil;
    _providerNameLabel.text = nil;
    _mainImageView.image = nil;
    [_deleteOrLockButton setImage:nil forState:UIControlStateNormal];
}

- (void)setCellContentWithMicroShopInfo:(MicroShopInfo *)info
{
    _shopInfo = info;
    
    _shopNameLabel.text = info.shopName;
    _providerNameLabel.text = info.shopProvider;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.shopImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    
    //判断是delete还是lock
    defaultStatus = [info.shopIsDefault intValue];
    switch (defaultStatus) {
        case Is_Locked:// 0：锁定
            [_deleteOrLockButton setImage:ImageNamed(@"lock") forState:UIControlStateNormal];
            break;
        case Is_Default:// 1：默认
            [_deleteOrLockButton setImage:nil forState:UIControlStateNormal];
            break;
        case Is_Else:// 2：其他
            [_deleteOrLockButton setImage:ImageNamed(@"delete") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)deleteOrLockButtonClicked:(id)sender {
    if (defaultStatus == Is_Else) {
        if ([self.delegate respondsToSelector:@selector(supportClickWithDeleteShopId:)]) {
            [self.delegate supportClickWithDeleteShopId:_shopInfo.shopId];
        }
    }
}
@end
