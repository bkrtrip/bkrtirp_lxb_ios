//
//  RegisterTowViewController.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterOneViewController.h"
#import "RegisterThreeViewController.h"
@interface RegisterTowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;//传过来的手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;//手机验证码
@property (weak, nonatomic) IBOutlet UIButton *gainPhoneCode;//倒计时，重新获取验证码

@end
