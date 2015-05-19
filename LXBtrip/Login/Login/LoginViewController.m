//
//  LoginViewController.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginRequestObjectManger.h"
@interface LoginViewController ()
-(IBAction)login:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}
-(void)buildUI{
    //创建导航栏右按钮
    UIButton * registerItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerItem setTitle:@"注册" forState:UIControlStateNormal];//设置按钮文字
    [registerItem setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:117.0/255.0 alpha:1] forState:UIControlStateNormal];//设置按钮文字颜色
    registerItem.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];//设置文字大小
    registerItem.frame = CGRectMake(0, 0, 30, 44); //设置右按钮的大小
    [registerItem addTarget:self action:@selector(registerClick:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * registerBarItem = [[UIBarButtonItem alloc]initWithCustomView:registerItem];
    self.navigationItem.rightBarButtonItem = registerBarItem;
#pragma 这页不是应该是首页吗？为什么会有返回键？我先给注释了
//    //设置导航栏返回键---------
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setTitle:@"" forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(0, 0, 10, 20);
//    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];//这个方法等上一个界面搭建了再实现
//    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backBarItem;
}
#pragma mark 点击下一步
-(void)registerClick:(UIButton *)item{
    if (!self.rOneVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.rOneVC = [sb instantiateViewControllerWithIdentifier:@"rOneVC"];
    }
    [self.navigationController pushViewController:self.rOneVC animated:YES];
}
#pragma mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
}
-(void)isActionLogin
{
    
    [LoginRequestObjectManger loginRequestNumberStr:self.phoneNumberText.text password:self.passwordText.text finished:^(int state) {
        switch (state) {
            case 0:
                //登陆成功，然后跳转相应的界面
                break;
            case 1:
                //登陆失败，弹出相应的提示，例如：账号或者密码错误
                break;
            case 2:
                //网络失败
                break;
                
            default:
                break;
        }
    }];
}
-(void)parsingPhoneNumberTextAndPasswordText//解析账号或者密码是否填写完整
{
    if (![self.phoneNumberText.text isEqualToString:@""]&&![self.passwordText.text isEqualToString:@""])
    {
        [self isActionLogin];
    }else
    {
        //提示账号或者密码填写要完整
    }
}
-(void)login:(id)sender
{
    [self parsingPhoneNumberTextAndPasswordText];
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
