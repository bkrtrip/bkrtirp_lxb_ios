//
//  FindPasswordViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/9.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()
@property(strong,nonatomic)phoneCodeViewController *phoneCodeVC;
@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}
-(void)buildUI{
    
    //创建导航栏右按钮
    
    UIButton * registerItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerItem setTitle:@"下一步" forState:UIControlStateNormal];//设置按钮文字
    [registerItem setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:117.0/255.0 alpha:1] forState:UIControlStateNormal];//设置按钮文字颜色
    registerItem.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];//设置文字大小
    registerItem.frame = CGRectMake(0, 0, 40, 44); ;
    [registerItem addTarget:self action:@selector(registerClick:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * registerBarItem = [[UIBarButtonItem alloc]initWithCustomView:registerItem];
    self.navigationItem.rightBarButtonItem = registerBarItem;
    //设置导航栏返回键
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 10, 20);
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
}
#pragma mark 点击下一步跳到下一个界面
-(void)registerClick:(UIButton *)item{
    if (!self.phoneCodeVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.phoneCodeVC = [sb instantiateViewControllerWithIdentifier:@"phoneCodeVC"];
    }
    [self.navigationController pushViewController:self.phoneCodeVC animated:YES];
}
#pragma mark 点击返回，回到上一界面
-(void)backClick:(UIButton *)item{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
