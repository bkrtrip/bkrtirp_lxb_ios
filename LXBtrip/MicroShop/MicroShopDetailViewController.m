//
//  MicroShopDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopDetailViewController.h"

@interface MicroShopDetailViewController ()

@property (strong, nonatomic) IBOutlet UIButton *addToMyShopButton;
- (IBAction)addToMyShopButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *hasAddedToMyShopButton;

@property (strong, nonatomic) IBOutlet UIImageView *shopImageView;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopProviderLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopIntroductionLabel;



@property (nonatomic, strong) MicroShopInfo *info;
@end

@implementation MicroShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItemWithRightBarItemTitle:nil];
    [self getShopDetail];
}

- (void)getShopDetail
{
    [HTTPTool getMicroShopDetailWithShopId:_shopId success:^(id result) {
        [[Global sharedGlobal] codeHudWithDict:result succeed:^{
            NSDictionary *data = result[@"RS100003"];
            _info = [[MicroShopInfo alloc] initWithDict:data];
            
            [_shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, _info.shopImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                ;
            }];
            
            _shopNameLabel.text = _info.shopName;
            _shopProviderLabel.text = _info.shopProvider;
            _shopTypeLabel.text = _info.shopType;
            _shopIntroductionLabel.text = _info.shopIntroduction;
            
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取微店详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)addToMyShopButtonClicked:(id)sender {
    
}
@end
