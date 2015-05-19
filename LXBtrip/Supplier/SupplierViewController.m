//
//  SupplierViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierViewController.h"

@interface SupplierViewController ()

@end

@implementation SupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)awakeFromNib{
    //等美工给图
    //标签栏图标
    self.tabBarItem.image = [[UIImage imageNamed:@"123"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //标签栏图标选中状态
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"1234"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
