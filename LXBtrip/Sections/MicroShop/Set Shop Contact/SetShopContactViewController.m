//
//  SetShopContactViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SetShopContactViewController.h"

@interface SetShopContactViewController ()
@property (strong, nonatomic) IBOutlet UITextField *shopContactTextField;

@end

@implementation SetShopContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微店联系人";
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"保存" image:nil];
}

- (void)rightBarButtonItemClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}







@end
