//
//  SetShopNameViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SetShopNameViewController.h"

@interface SetShopNameViewController ()

@property (strong, nonatomic) IBOutlet UITextField *shopNameTextField;
@end

@implementation SetShopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}








@end
