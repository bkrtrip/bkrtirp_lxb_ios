//
//  SetShopContactViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SetShopContactViewController.h"
#import "SupplierDetailViewController.h"

@interface SetShopContactViewController ()
@property (strong, nonatomic) IBOutlet UITextField *shopContactTextField;

@end

@implementation SetShopContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微店联系人";
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存" image:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = SCREEN_WIDTH/(828.f/304.f) + 52.f + 3.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin - 49.f];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)rightBarButtonItemClicked:(id)sender
{
    if (_shopContactTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写微店联系人" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool setSelfInfoWithStaffId:[UserModel staffId] companyId:[UserModel companyId] avatarString:nil contactName:_shopContactTextField.text shopName:_shopName phoneNumber:nil provinceId:nil provinceName:nil cityId:nil cityName:nil areaId:nil areaName:nil address:nil success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        [[Global sharedGlobal] codeHudWithObject:result[@"RS100024"] succeed:^{
            // 更新本地用户信息
            [UserModel updateUserProperty:_shopName ForKey:@"staff_real_name"];
            [UserModel updateUserProperty:_shopContactTextField.text ForKey:@"staff_departments_name"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微店信息设置成功！" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
            
            NSInteger stackControllersCount = self.navigationController.viewControllers.count;
            if (stackControllersCount > 3) {
                NSInteger supplierDetailIndex = stackControllersCount - 3;
                UIViewController *supplierDetailOrMicroshop = self.navigationController.viewControllers[supplierDetailIndex];
                [self.navigationController popToViewController:supplierDetailOrMicroshop animated:YES];
            }
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];

        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微店信息设置失败！" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}



@end
