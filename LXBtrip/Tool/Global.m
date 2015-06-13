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

// compare function
NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context)
{
    return [initial_1 caseInsensitiveCompare:initial_2];
}

- (void)saveSearchHistory:(NSArray *)historyArray
{
    NSMutableArray *history = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_history"];
    [history addObjectsFromArray:historyArray];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"search_history"];
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"search_history"];
}

- (NSMutableArray *)searchHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"search_history"];
}

- (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"search_history"];
}

- (void)codeHudWithObject:(id)obj succeed:(errorCode_succeed_block)succeed fail:(FailBlock)fail
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        ErrorCodeType type = [obj[@"error_code"] intValue];
        switch (type) {
            case ERROR_CODE_ERROR: //错误
            {
                if (succeed) {
                    succeed(nil);
                }
            }
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
        fail(nil);
    } else {
        succeed(nil);
    }
}

- (UIViewController *)loginViewControllerFromSb
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:[NSBundle mainBundle]];
    return [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}




@end
