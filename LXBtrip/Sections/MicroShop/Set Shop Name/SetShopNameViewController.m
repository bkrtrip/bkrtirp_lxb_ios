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
    [self setUpNavigationItem:self.navigationItem withRightBarItemTitle:@"下一步"];
}

- (void)rightBarButtonItemClicked:(id)sender
{
    SetShopContactViewController *setContact = [[SetShopContactViewController alloc] init];
    [self.navigationController pushViewController:setContact animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}







@end
