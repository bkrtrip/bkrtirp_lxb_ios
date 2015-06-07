//
//  MyOrderListTableViewCell__Unconfirmed_Confirmed.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate <NSObject>

- (void)supportClickWithPhoneCall;
- (void)supportClickWithCancelOrder;

@end

@interface MyOrderListTableViewCell__Unconfirmed_Confirmed : UITableViewCell

@property (nonatomic, weak) id <MyOrderListTableViewCell__Unconfirmed_Confirmed_Delegate> delegate;

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item;
@end
