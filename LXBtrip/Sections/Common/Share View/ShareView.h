//
//  ShareView.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

- (void)supportClickWithQQWithShareObject:(id)obj;
- (void)supportClickWithWeChatWithShareObject:(id)obj;
- (void)supportClickWithFriendsWithShareObject:(id)obj;
- (void)supportClickWithShortMessageWithShareObject:(id)obj;
- (void)supportClickWithSendingToComputerWithShareObject:(id)obj;
- (void)supportClickWithWeiboWithShareObject:(id)obj;
- (void)supportClickWithQZoneWithShareObject:(id)obj;
- (void)supportClickWithYiXinWithShareObject:(id)obj;

@end

@interface ShareView : UIView

@property (nonatomic, weak) id <ShareViewDelegate>delegate;

- (CGFloat)shareViewHeightWithShareObject:(id)object;

@end
