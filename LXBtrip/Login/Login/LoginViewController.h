//
//  LoginViewController.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterOneViewController.h"
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;//登陆手机号
@property (weak, nonatomic) IBOutlet UITextField *passwordText;//登陆密码
@property (weak, nonatomic) IBOutlet UITextField *loginItem;//登陆按钮
@property (strong, nonatomic)RegisterOneViewController *rOneVC;

@end
