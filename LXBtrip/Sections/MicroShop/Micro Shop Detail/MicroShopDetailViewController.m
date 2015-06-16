//
//  MicroShopDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopDetailViewController.h"

@interface MicroShopDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
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
//    self.automaticallyAdjustsScrollViewInsets = YES;

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
        }];
        
        _shopNameLabel.text = _info.shopName;
        _shopProviderLabel.text = _info.shopProvider;
        
        TemplateType templateType = [_info.shopType intValue];
        switch (templateType) {
            case Exclusive_Shop:// 专卖
                _shopTypeLabel.text = @"专卖";
                break;
            case Template_By_LXB:// 模板（旅小宝提供）
                _shopTypeLabel.text = @"模板（旅小宝提供）";
                break;
            case Template_By_Supplier:// 模板（供应商提供）
                _shopTypeLabel.text = @"模板（供应商提供）";
                break;
            default:
                break;
        }
        
        _shopIntroductionLabel.text = _info.shopIntroduction;

        _shopMonthUsageLabel.text = [NSString stringWithFormat:@"%@次", _info.shopUsageAmount];
        
        CGSize instructionSize = [_shopIntroductionLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20.f - 60.f - 20.f, MAXFLOAT)];
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 580.f + instructionSize.height)];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取微店详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)addToMyShopButtonClicked:(id)sender {
    if (![UserModel companyId] || ![UserModel staffId]) {
        // go to login page
        
    } else
    {
        // add to myshop
        [HTTPTool addToMyShopWithShopId:_shopId companyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            id obj = result[@"RS100004"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                _addToMyShopButton.hidden = YES;
                _hasAddedToMyShopButton.hidden = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOP_LIST_NEEDS_UPDATE" object:self];
            } fail:^(id result) {
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}
@end
