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
    // Do any additional setup after loading the view from its nib.
}

// subclass must override
- (void)setUpNavigationItemWithRightBarItemTitle:(NSString *)title
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftBackBarItemWithAction:@selector(backClick:) target:self];

    [[Global sharedGlobal] whiteStyle:self.navigationController barItem:self.navigationItem rightItemTitle:title];
}

- (void)backClick:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
