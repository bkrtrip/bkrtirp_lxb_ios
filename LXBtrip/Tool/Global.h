//
//  Global.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/23.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacro.h"

typedef void (^errorCode_succeed_block)();


@interface Global : NSObject
singleton_interface(Global)

// compare function
NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context);

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


@end
