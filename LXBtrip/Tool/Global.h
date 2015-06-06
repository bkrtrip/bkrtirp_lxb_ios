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


@property (nonatomic, strong) User *userInfo;
@property (nonatomic, copy) NSMutableArray *searchHistory;

// compare function
NSInteger initialSort(NSString * initial_1, NSString * initial_2, void *context);

- (void)saveUserInfo:(User *)userInfo;
- (void)saveSearchHistory:(NSArray *)historyArray;
- (void)clearSearchHistory;
- (void)codeHudWithObject:(id)obj succeed:(errorCode_succeed_block)succeed;// 根据错误码显示HUD

@end
