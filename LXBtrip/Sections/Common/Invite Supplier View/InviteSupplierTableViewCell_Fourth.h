//
//  InviteSupplierTableViewCell_Fourth.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteSupplierTableViewCell_Fourth_Delegate <NSObject>

- (void)supportClickWithQQ;
- (void)supportClickWithWeChat;
- (void)supportClickWithPhoneCall;
- (void)supportClickWithShortMessage;

@end

@interface InviteSupplierTableViewCell_Fourth : UITableViewCell

@property (nonatomic, weak) id <InviteSupplierTableViewCell_Fourth_Delegate>delegate;

@end
