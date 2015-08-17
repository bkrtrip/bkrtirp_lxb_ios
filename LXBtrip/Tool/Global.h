//
//  Global.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacro.h"
#import <CoreLocation/CoreLocation.h>

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

typedef void (^errorCode_succeed_block)();

@interface Global : NSObject
singleton_interface(Global)

// compare function
NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context);
NSInteger sortFirstLetter(NSString * letter_1, NSString * letter_2, void *context);
NSInteger sortOrder(MyOrderItem * order_1, MyOrderItem * order_2, void *context);


- (void)saveToSearchHistoryWithKeyword:(NSString *)keyword;
- (NSMutableArray *)searchHistory;
- (void)clearSearchHistory;
- (void)codeHudWithObject:(id)obj succeed:(errorCode_succeed_block)succeed;// 根据错误码显示HUD

- (void)saveToHotCityHistoryWithCityName:(NSString *)cityName;
- (NSMutableArray *)hotCityHistory;

- (UINavigationController *)loginNavViewControllerFromSb;

- (void)setNetworkAvailability:(BOOL)networkAvailability;
- (BOOL)networkAvailability;

- (BOOL)notFirstLogin;
- (void)saveNotFirstLoginStatus;

- (NSString *)replaceUnicode:(NSString *)unicodeStr;
- (NSString *)weekDayFromDateString:(NSString *)dateString;
- (NSComparisonResult)compareDateStringOne:(NSString *)one withDateStringTwo:(NSString *)two;

- (NSString *)locationProvince;
- (NSString *)locationCity;
- (void)upDateLocationProvince:(NSString *)newProvince;
- (void)upDateLocationCity:(NSString *)newCity;
- (CLLocation *)locationCoordinate;
- (void)upDateLocationCoordinate:(CLLocation *)coordinate;

- (NSString *)userSavedCity_Supplier;
- (void)upDateUserSavedCity_Supplier:(NSString *)newCity;

- (NSString *)userSavedCity_TourList;
- (void)upDateUserSavedCity_TourList:(NSString *)newCity;

- (NSString *)userSavedCity_SearchSupplierResults;
- (void)upDateUserSavedCity_SearchSupplierResults:(NSString *)newCity;

- (void)callWithPhoneNumber:(NSString *)phoneNumber;
- (void)sendShortTextWithPhoneNumber:(NSString *)phoneNumber;

- (void)setUnderlinedWithText:(NSString *)text button:(UIButton *)button color:(UIColor *)color;

// 用户头像
- (void)saveUserAvatarWithImage:(UIImage *)image;
- (UIImage *)userAvatar;

#pragma mark - Share part
// Wechat
- (void)shareViaWeChatWithURLString:(NSString *)shareURL title:(NSString *)title content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(WechatShareType)type;

// QQ
- (void)shareViaQQWithURLString:(NSString *)shareURL title:(NSString *)title content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(QQShareType)type;

// Sina
- (void)shareViaSinaWithURLString:(NSString *)shareURL content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController;


// YiXin
- (void)shareViaYiXinWithURLString:(NSString *)shareURL content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController shareType:(YiXinShareType)type;

// SMS
- (void)shareViaSMSWithContent:(NSString *)content presentedController:(UIViewController *)presentedController;


@end
