//
//  SmailShopViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SmailShopViewController.h"

@interface SmailShopViewController ()
@property(assign,nonatomic)BOOL isYES;
@end

@implementation SmailShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置点击后的颜色渲染（等美工给色值）
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.2 green:0.1 blue:0.5 alpha:1];

}
#pragma mark 设置标签栏按钮图片
-(void)awakeFromNib{
    //等美工给图
    //标签栏图标（等美工给图）
    self.tabBarItem.image = [[UIImage imageNamed:@"123"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //标签栏图标选中状态（等美工给图）
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"1234"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
#pragma mark 点击在线微店
- (IBAction)doOnLineShop:(id)sender {
        self.OnLineShop.tintColor = [UIColor redColor];
    self.MyShop.tintColor = [UIColor blackColor];
}
#pragma mark 点击我的微店
- (IBAction)doMyShop:(id)sender {
    self.MyShop.tintColor = [UIColor redColor];
    self.OnLineShop.tintColor = [UIColor blackColor];
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
