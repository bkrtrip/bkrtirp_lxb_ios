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
@property (strong, nonatomic) IBOutlet UILabel *shopMonthUsageLabel;



@property (nonatomic, strong) MicroShopInfo *info;
@end

@implementation MicroShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShopDetail];
    self.title = @"微店详情";
    
    if (_isMyShop == NO) {
        _addToMyShopButton.hidden = NO;
        _hasAddedToMyShopButton.hidden = YES;
    } else {
        _addToMyShopButton.hidden = YES;
        _hasAddedToMyShopButton.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)getShopDetail
{
    [HTTPTool getMicroShopDetailWithShopId:_shopId success:^(id result) {
        NSDictionary *data = result[@"RS100003"];
        _info = [[MicroShopInfo alloc] initWithDict:data];
        
        [_shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, _info.shopImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ;
            _shopNameLabel.text = _info.shopName;
            _shopProviderLabel.text = _info.shopProvider;
            _shopTypeLabel.text = _info.shopType;
            _shopIntroductionLabel.text = _info.shopIntroduction;
            _shopMonthUsageLabel.text = [NSString stringWithFormat:@"%@次", _info.shopUsageAmount];
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取微店详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)addToMyShopButtonClicked:(id)sender {
    if (![[Global sharedGlobal] userInfo].token) {
        // go to login page
    } else
    {
        // add to myshop
        [HTTPTool addToMyShopWithShopId:_shopId companyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId success:^(id result) {
            NSDictionary *dict = result[@"RS100004"];
            [[Global sharedGlobal] codeHudWithDict:dict succeed:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                _addToMyShopButton.hidden = YES;
                _hasAddedToMyShopButton.hidden = NO;
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}
@end
