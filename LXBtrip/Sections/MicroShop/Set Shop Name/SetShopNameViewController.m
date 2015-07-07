//
//  SetShopNameViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SetShopNameViewController.h"
#import "SetShopContactViewController.h"

@interface SetShopNameViewController ()

@property (strong, nonatomic) IBOutlet UITextField *shopNameTextField;
@end

@implementation SetShopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微店名称";
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"下一步" image:nil];
}

- (void)rightBarButtonItemClicked:(id)sender
{
    if (_shopNameTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写微店名称" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool setSelfInfoWithStaffId:[UserModel staffId] companyId:[UserModel companyId] avatarString:nil contactName:nil shopName:_shopNameTextField.text phoneNumber:nil provinceId:nil provinceName:nil cityId:nil cityName:nil areaId:nil areaName:nil address:nil success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100024"] succeed:^{
            // 更新本地用户信息
            [UserModel updateUserProperty:_shopNameTextField.text ForKey:@"staff_departments_name"];
            
            SetShopContactViewController *setContact = [[SetShopContactViewController alloc] init];
            setContact.isFromSetShopName = YES;
            [self.navigationController pushViewController:setContact animated:YES];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}




@end
