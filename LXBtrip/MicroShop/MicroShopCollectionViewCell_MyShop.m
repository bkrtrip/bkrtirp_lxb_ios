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

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) IBOutlet UIButton *deleteOrLockButton;
- (IBAction)deleteOrLockButtonClicked:(id)sender;

@end

@implementation MicroShopCollectionViewCell_MyShop

- (void)awakeFromNib {
    // Initialization code
    _shopNameLabel.text = nil;
    _providerNameLabel.text = nil;
    _mainImageView.image = nil;
    [_deleteOrLockButton setImage:nil forState:UIControlStateNormal];
}

- (void)setCellContentWithMicroShopInfo:(MicroShopInfo *)info
{
    _shopNameLabel.text = info.shopName;
    _providerNameLabel.text = info.shopProvider;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.shopImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    
    //判断是delete还是lock
    
    TemplateDefaultStatus defaultStatus = [info.shopIsDefault intValue];
    switch (defaultStatus) {
        case Is_Default:
            <#statements#>
            break;
            
        default:
            break;
    }
//    _deleteOrLockButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>
}


- (IBAction)deleteOrLockButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithDeleteButton)]) {
        [self.delegate supportClickWithDeleteButton];
    }
}
@end
