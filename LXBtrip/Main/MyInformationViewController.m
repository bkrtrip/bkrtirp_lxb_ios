//
//  MyInformationViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyInformationViewController.h"

@interface MyInformationViewController ()

@end

@implementation MyInformationViewController

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
-(void)buildUI{
    //设置头部image
    self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"5.png"]];//记得换图，美工给图
    self.headImageView.frame = CGRectZero;
    self.headImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.headImageView];
    
   //我的供应商按钮
    self.supplierButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.supplierButton setImage:[UIImage imageNamed:@"我的供应商.png"] forState:UIControlStateNormal];
    self.supplierButton.frame = CGRectZero;
    self.supplierButton.translatesAutoresizingMaskIntoConstraints = NO;
    //这里记得要添加动作
    /*
    [self.supplierButton addTarget:self action:@selector(动作动作) forControlEvents:UIControlEventTouchUpInside];
     */
    [self.view addSubview:self.supplierButton];
    
    //我的分销商按钮
    self.distributorButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.distributorButton setImage:[UIImage imageNamed:@"我的分销商.png"] forState:UIControlStateNormal];
    self.distributorButton.frame = CGRectZero;
    self.distributorButton.translatesAutoresizingMaskIntoConstraints = NO;
    //这里记得要添加动作
   /*
     [self.distributorButton addTarget:self action:@selector(动作动作) forControlEvents:UIControlEventTouchUpInside];
    */
    [self.view addSubview:self.supplierButton];
    
    //我的订单按钮
    self.orderFormButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.orderFormButton setImage:[UIImage imageNamed:@"我的订单.png"] forState:UIControlStateNormal];
    self.orderFormButton.frame = CGRectZero;
    self.orderFormButton.translatesAutoresizingMaskIntoConstraints = NO;
    //这里记得要添加动作
    /*
    [self.orderFormButton addTarget:self action:@selector(动作动作) forControlEvents:UIControlEventTouchUpInside];
     */
    //创建表示视图
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    //先不写数据源
    
    
    
    
    
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
