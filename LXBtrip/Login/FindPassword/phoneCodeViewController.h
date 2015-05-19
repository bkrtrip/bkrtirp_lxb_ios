//
//  phoneCodeViewController.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/9.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetPasswordViewController.h"
@interface phoneCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberText;//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneCode;//手机验证码
@property (weak, nonatomic) IBOutlet UIButton *gainPhoneCode;//获取验证码按钮

@end
