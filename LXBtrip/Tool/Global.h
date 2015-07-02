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
- (void)callWithPhoneNumber:(NSString *)phoneNumber;
- (void)sendShortTextWithPhoneNumber:(NSString *)phoneNumber;

- (void)setUnderlinedWithText:(NSString *)text button:(UIButton *)button color:(UIColor *)color;

#pragma mark - Share part
// Wechat
- (void)shareViaWeChatWithURLString:(NSString *)shareURL content:(NSString *)content image:(id)image location:(CLLocation *)location presentedController:(UIViewController *)presentedController;

@end
