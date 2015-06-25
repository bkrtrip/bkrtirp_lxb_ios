//
//  NoNetworkView.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol NoNetworkView_Delegate <NSObject>

- (void)supportClickWithRetryNetworkReachability;

@end

@interface NoNetworkView : UIWindow
singleton_interface(NoNetworkView)

@property (nonatomic, weak) id <NoNetworkView_Delegate> noNetworkView_Delegate;
- (void)showWithYOrigin:(CGFloat)yOrigin height:(CGFloat)height;
- (void)hide;

@end
