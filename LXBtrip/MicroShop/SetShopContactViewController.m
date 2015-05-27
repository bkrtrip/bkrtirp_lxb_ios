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
    [self setUpNavigationItemWithRightBarItemTitle:@"保存"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
