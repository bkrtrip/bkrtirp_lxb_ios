//
//  Global.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "Global.h"
#import <TencentOpenAPI/QQApiInterface.h>       //QQ互联 SDK

const NSString *kNotFirstLogin = @"not_first_login";
const NSString *kSearchHistory = @"search_history";
const NSString *kHotCityHistory = @"hot_city_history";

const NSString *kLocationProvince = @"location_province";
const NSString *kLocationCity = @"location_city";

const NSString *kLocationLatitude = @"latitude";
const NSString *kLocationLongitude = @"longitude";


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
NSInteger sortFirstLetter(NSString * letter_1, NSString * letter_2, void *context) {
    NSInteger diff = [letter_1 integerValue] - [letter_2 integerValue];
    if (diff > 0) {
        return NSOrderedDescending;
    } else if (diff < 0) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}
NSInteger sortOrder(MyOrderItem * order_1, MyOrderItem * order_2, void *context) {
    return [order_2.orderLineNo caseInsensitiveCompare:order_1.orderLineNo];
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
    
//    NSString *tempStr4 = [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    NSString *returnStr1 = [returnStr stringByReplacingOccurrencesOfString:@"<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>"withString:@"\n"];
    NSString *returnStr2 = [returnStr1 stringByReplacingOccurrencesOfString:@"<br/><br/><br/><br/><br/><br/><br/><br/>"withString:@"\n"];
    NSString *returnStr3 = [returnStr2 stringByReplacingOccurrencesOfString:@"<br/><br/><br/><br/>"withString:@"\n"];
    NSString *returnStr4 = [returnStr3 stringByReplacingOccurrencesOfString:@"<br/><br/>"withString:@"\n"];
    
    NSString *finalStr = [returnStr4 stringByReplacingOccurrencesOfString:@"<br/>"withString:@"\n"];
    
    NSRange range = [finalStr rangeOfString:@"5："];
    if (range.length > 0) {
        NSString *subStr = [finalStr substringWithRange:NSMakeRange(range.location-1, 1)];
        if ([subStr isEqualToString:@"。"]) {
            finalStr = [[finalStr substringToIndex:range.location] stringByAppendingFormat:@"\n%@", [finalStr substringFromIndex:range.location]];
        }
    }

    return finalStr;
}

- (NSString *)weekDayFromDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    NSInteger cellWeekDay = [comps weekday];

    switch (cellWeekDay) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return nil;
            break;
    }
}

- (NSComparisonResult)compareDateStringOne:(NSString *)one withDateStringTwo:(NSString *)two
{
    NSArray *oneComponents = [one componentsSeparatedByString:@"-"];
    NSArray *twoComponents = [two componentsSeparatedByString:@"-"];
    
    if ([oneComponents[0] integerValue] > [twoComponents[0] integerValue]) {
        return NSOrderedDescending;
    }
    
    if ([oneComponents[0] integerValue] < [twoComponents[0] integerValue]) {
        return NSOrderedAscending;
    }
    
    if ([oneComponents[1] integerValue] > [twoComponents[1] integerValue]) {
        return NSOrderedDescending;
    }
    
    if ([oneComponents[1] integerValue] < [twoComponents[1] integerValue]) {
        return NSOrderedAscending;
    }
    
    if ([oneComponents[2] integerValue] > [twoComponents[2] integerValue]) {
        return NSOrderedDescending;
    }
    
    if ([oneComponents[2] integerValue] < [twoComponents[2] integerValue]) {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

- (NSString *)locationProvince
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kLocationProvince];
}
- (NSString *)locationCity
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kLocationCity];
}
- (void)upDateLocationProvince:(NSString *)newProvince
{
    [[NSUserDefaults standardUserDefaults] setObject:newProvince forKey:(NSString *)kLocationProvince];
}
- (void)upDateLocationCity:(NSString *)newCity
{
    [[NSUserDefaults standardUserDefaults] setObject:newCity forKey:(NSString *)kLocationCity];
}
- (CLLocation *)locationCoordinate
{
    CGFloat lat = [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kLocationLatitude] floatValue];
    CGFloat lon = [[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kLocationLongitude] floatValue];
    return [[CLLocation alloc] initWithLatitude:lat longitude:lon];
}
- (void)upDateLocationCoordinate:(CLLocation *)coordinate
{
    CGFloat lat = coordinate.coordinate.latitude;
    CGFloat lon = coordinate.coordinate.longitude;
    [[NSUserDefaults standardUserDefaults] setObject:@(lat) forKey:(NSString *)kLocationLatitude];
    [[NSUserDefaults standardUserDefaults] setObject:@(lon) forKey:(NSString *)kLocationLongitude];
}

// call
- (void)callWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    if (url && url.absoluteString.length > 0) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"电话号码格式错误" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

// SMS
- (void)sendShortTextWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *urlString = [NSString stringWithFormat:@"sms:%@", phoneNumber];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    if (url && url.absoluteString.length > 0) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"电话号码格式错误" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

// Underline
- (void)setUnderlinedWithText:(NSString *)text button:(UIButton *)button color:(UIColor *)color
{
    if (text) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:color range:strRange];
        [button setAttributedTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark - Share part
// Wechat
- (void)shareViaWeChatWithURLString:(NSString *)shareURL title:(NSString *)title content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(WechatShareType)type
{
    if (!image) {
        image = ImageNamed(@"share_icon");
    }
    if (!title) {
        title = content;
    }
    switch (type) {
        case Wechat_Share_Session:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
        case Wechat_Share_Timeline:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        default:
            break;
    }
}

// QQ
- (void)shareViaQQWithURLString:(NSString *)shareURL title:(NSString *)title content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(QQShareType)type
{
    if ([QQApiInterface isQQInstalled] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!image) {
        image = ImageNamed(@"share_icon");
    }
    if (!title) {
        title = content;
    }
    switch (type) {
        case QQ_Share_Session:
        {
            [UMSocialData defaultData].extConfig.qqData.url = shareURL;
            [UMSocialData defaultData].extConfig.qqData.title = title;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
        case QQ_Share_QZone://Qzone分享文字与图片缺一不可，否则会出现错误码10001
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
            [UMSocialData defaultData].extConfig.qzoneData.title = title;
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        default:
            break;
    }
}

// Sina
- (void)shareViaSinaWithURLString:(NSString *)shareURL content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController
{
    if (!image) {
        image = ImageNamed(@"share_icon");
    }
    
    NSString * shareText = [NSString stringWithFormat:@"%@ \n%@", content, shareURL];
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:image socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(presentedController, [UMSocialControllerService defaultControllerService],YES);
}

// YiXin
- (void)shareViaYiXinWithURLString:(NSString *)shareURL content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(YiXinShareType)type
{
    if (!image) {
        image = ImageNamed(@"share_icon");
    }
    switch (type) {
        case YiXin_Share_Session:
        {
            [UMSocialData defaultData].extConfig.yxsessionData.url = shareURL;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToYXSession] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
        case YiXin_Share_Timeline://Qzone分享文字与图片缺一不可，否则会出现错误码10001
        {
            [UMSocialData defaultData].extConfig.yxtimelineData.url = shareURL;
            
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToYXTimeline] content:content image:image location:location urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
        default:
            break;
    }
}

// SMS
- (void)shareViaSMSWithContent:(NSString *)content presentedController:(UIViewController *)presentedController
{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:content image:nil location:nil urlResource:nil presentedController:presentedController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
        }
    }];
}


@end
