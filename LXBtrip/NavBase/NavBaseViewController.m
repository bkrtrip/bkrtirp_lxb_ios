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
    
    // left back arrow
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [leftBtn setImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:MainNavTitleFont};
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

// subclass with rightBarButtonItem Title override
- (void)setUpNavigationItem:(UINavigationItem *)item withRightBarItemTitle:(NSString *)title
{
    // right text
    if (title) {
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor = RED_FF0075;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

- (void)backArrowClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
