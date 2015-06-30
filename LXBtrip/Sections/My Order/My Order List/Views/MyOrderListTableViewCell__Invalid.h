//
//  MyOrderListTableViewCell__Invalid.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol MyOrderListTableViewCell__Invalid_Delegate <NSObject>

- (void)supportClickWithPhoneCall_InvalidWithOrder:(MyOrderItem *)order;

@end

@interface MyOrderListTableViewCell__Invalid : UITableViewCell

@property (nonatomic, weak) id <MyOrderListTableViewCell__Invalid_Delegate> delegate;

- (void)setCellContentWithMyOrderItem:(MyOrderItem *)item;

@end
