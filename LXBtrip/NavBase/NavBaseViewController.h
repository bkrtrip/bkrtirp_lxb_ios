//
//  NavBaseViewController.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface NavBaseViewController : UIViewController

- (void)backClick:(UIBarButtonItem *)item;
- (void)setUpNavigationItemWithRightBarItemTitle:(NSString *)title;

@end
