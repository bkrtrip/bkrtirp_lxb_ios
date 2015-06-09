//
//  PHeaderTableViewCell.h
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GoToSuppliers,
    GoToDispatchers,
    GoToOrders,
    GoToInfoSettings,
    GoToRegister,
    GoToLogin
} ActionType;

@protocol HeaderActionProtocol <NSObject>

- (void)responseForAction:(ActionType)action;

@end

@interface PHeaderTableViewCell : UITableViewCell


@property (weak, nonatomic) id<HeaderActionProtocol> delegate;

- (void)initialHeaderViewWithUserInfo:(NSDictionary *)userInfoDic;
@end
