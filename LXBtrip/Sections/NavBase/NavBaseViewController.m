//
//  NavBaseViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "NavBaseViewController.h"

@interface NavBaseViewController ()

@end

@implementation NavBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barTintColor = BG_F5F5F5;
    self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // left back arrow
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 40, 44)];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:MainNavTitleFont};
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkUnavailable) name:@"NETWORK_UNAVAILABLE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkAvailable) name:@"NETWORK_AVAILABLE" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NETWORK_UNAVAILABLE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NETWORK_AVAILABLE" object:nil];
}

- (void)networkUnavailable
{
    // for subclass to override
}

- (void)networkAvailable
{
    // for subclass to override
    [[NoNetworkView sharedNoNetworkView] hide];
}

// for subclass to override
- (void)setUpNavigationItem:(UINavigationItem *)item withRightBarItemTitle:(NSString *)title image:(UIImage *)img
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    // right text
    if (title) {
        [rightBtn setTitleColor:RED_FF0075 forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor = RED_FF0075;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    
    // right image
    if (img) {
        [rightBtn setImage:img forState:UIControlStateNormal];
    }
    
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)backArrowClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// for subclass to override
- (void)rightBarButtonItemClicked:(id)sender {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
