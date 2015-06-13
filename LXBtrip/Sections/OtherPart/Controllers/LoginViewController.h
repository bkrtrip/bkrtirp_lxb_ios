//
//  LoginViewController.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPhoneNumViewController.h"
#import "AppMacro.h"

@protocol LoginVCProtocol <NSObject>

- (void)loginSuccess;

@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<LoginVCProtocol> delegate;

@end
