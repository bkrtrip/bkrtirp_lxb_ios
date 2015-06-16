//
//  CreateOrderCell_Confirm.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol CreateOrderCell_Confirm_Delegate <NSObject>

- (void)supportClickConfirmModification;

@end

@interface CreateOrderCell_Confirm : UITableViewCell

@property (nonatomic, weak) id <CreateOrderCell_Confirm_Delegate> delegate;
- (void)setCellContentWithOrder:(MyOrderItem *)order;

@end
