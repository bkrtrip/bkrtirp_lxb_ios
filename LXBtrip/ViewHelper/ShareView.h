//
//  ShareView.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

- (void)supportClickWithQQ;
- (void)supportClickWithWeChat;
- (void)supportClickWithFriends;
- (void)supportClickWithShortMessage;
- (void)supportClickWithSendingToComputer;
- (void)supportClickWithWeibo;
- (void)supportClickWithQZone;
- (void)supportClickWithYiXin;

@end

@interface ShareView : UIView

@property (nonatomic, weak) id <ShareViewDelegate>delegate;

@end
