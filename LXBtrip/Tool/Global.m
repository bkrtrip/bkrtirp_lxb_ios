//
//  Global.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "Global.h"

const NSString *kNotFirstLogin = @"not_first_login";
const NSString *kSearchHistory = @"search_history";
const NSString *kHotCityHistory = @"hot_city_history";

@interface Global()

@property (nonatomic, assign) BOOL networkAvailability;

@end

@implementation Global
@synthesize networkAvailability = _networkAvailability;
singleton_implementation(Global)

// compare function
NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context) {
    return [initial_1 caseInsensitiveCompare:initial_2];
}

// search history
- (void)saveToSearchHistoryWithKeyword:(NSString *)keyword {
    NSMutableArray *history = [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kSearchHistory] mutableCopy];
    if (!history) {
        history = [[NSMutableArray alloc] init];
    }
    
    __block BOOL alreadyOld = NO;
    [history enumerateObjectsUsingBlock:^(NSString *oldSearch, NSUInteger idx, BOOL *stop) {
        if ([oldSearch isEqualToString:keyword]) {
            alreadyOld = YES;
        }
    }];
    if (alreadyOld == NO) {
        [history insertObject:keyword atIndex:0]; // 确保后保存的先显示
        [[NSUserDefaults standardUserDefaults] setObject:history forKey:(NSString *)kSearchHistory];
    }
}
- (NSMutableArray *)searchHistory {
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kSearchHistory];
}
- (void)clearSearchHistory {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:(NSString *)kSearchHistory];
}

// hot city
- (void)saveToHotCityHistoryWithCityName:(NSString *)cityName {
    NSMutableArray *history = [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kHotCityHistory] mutableCopy];
    if (!history) {
        history = [[NSMutableArray alloc] init];
    }
    
    __block BOOL alreadyOld = NO;
    [history enumerateObjectsUsingBlock:^(NSString *oldCity, NSUInteger idx, BOOL *stop) {
        if ([oldCity isEqualToString:cityName]) {
            alreadyOld = YES;
        }
    }];
    if (alreadyOld == NO) {
        [history insertObject:cityName atIndex:0]; // 确保后保存的先显示
        [[NSUserDefaults standardUserDefaults] setObject:history forKey:(NSString *)kHotCityHistory];
    }
}
- (NSMutableArray *)hotCityHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kHotCityHistory];
}

// 返回值判断
- (void)codeHudWithObject:(id)obj succeed:(errorCode_succeed_block)succeed
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        ErrorCodeType type = [obj[@"error_code"] intValue];
        switch (type) {
            case ERROR_CODE_ERROR: //错误
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
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
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询无数据" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//                [alert show];
                
                if (succeed) {
                    succeed(nil);
                }
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
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未知错误" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
            }
                break;
        }
    } else {
        if (succeed) {
            succeed(nil);
        }
    }
}

- (UINavigationController *)loginNavViewControllerFromSb
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:[NSBundle mainBundle]];
    UIViewController *login = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    return NavC(login);
}

- (void)setNetworkAvailability:(BOOL)networkAvailability
{
    _networkAvailability = networkAvailability;
}

- (BOOL)networkAvailability
{
    return _networkAvailability;
}

- (BOOL)notFirstLogin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kNotFirstLogin] boolValue];
}
- (void)saveNotFirstLoginStatus
{
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:(NSString *)kNotFirstLogin];
}

//unicode编码以\u开头
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    if (!unicodeStr) {
        return nil;
    }
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
    NSString *tempStr4 = [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    return [tempStr4 stringByReplacingOccurrencesOfString:@"<br/>"withString:@"\n"];
}

@end
