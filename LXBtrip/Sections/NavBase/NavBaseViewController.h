//
//  NavBaseViewController.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "AppMacro.h"

@interface NavBaseViewController : UIViewController

// for subclass to override
- (void)setUpNavigationItem:(UINavigationItem *)item withRightBarItemTitle:(NSString *)title image:(UIImage *)img;
- (void)rightBarButtonItemClicked:(id)sender;
- (void)backArrowClick:(id)sender;

- (void)networkUnavailable;
- (void)networkAvailable;

@end
