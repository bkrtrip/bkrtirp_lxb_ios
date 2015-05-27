//
//  Global.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "Global.h"

@implementation Global
singleton_implementation(Global)

- (void)saveUserInfo:(User *)userInfo
{
    // after login, save user info here.
}

-(void)whiteStyle:(UINavigationController *)nav barItem:(UINavigationItem *)barItem rightItemTitle:(NSString *)title
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    
    // left back arrow
    UIBarButtonItem  * leftItem = barItem.leftBarButtonItems[1];
    UIButton * btn = (UIButton *)leftItem.customView;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    // right text
    if (title) {
        UIBarButtonItem *rightItem = barItem.rightBarButtonItems[1];
        btn = (UIButton *)rightItem.customView;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.textColor = CUSTOM_RED_COLOR;
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:MainNavTitleFont};
    nav.navigationBar.backgroundColor = [UIColor whiteColor];
}


- (void)codeHudWithDict:(NSDictionary *)dict succeed:(errorCode_succeed_block)succeed
{
    ErrorCodeType type = [dict[@"error_code"] intValue];
    switch (type) {
        case ERROR_CODE_SUCCESSFUL: //成功
        {
            if (succeed) {
                succeed(nil);
            }
        }
            break;
        case ERROR_CODE_NO_DATA: //查询无数据
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询无数据" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ERROR_CODE_TOKEN_INVALID: //TOKEN不合法
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TOKEN不合法" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ERROR_CODE_CODE_ILLEGAL: //接口CODE不合法
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接口CODE不合法" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ERROR_CODE_MISSING_ARGUMENT: //缺少参数
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"缺少参数" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ERROR_CODE_ARGUMENT_ILLEGAL: //参数不合法
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"参数不合法" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ERROR_CODE_DATE_FORMAT_INCORRECT: //日期格式错误
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"日期格式错误" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}




@end
