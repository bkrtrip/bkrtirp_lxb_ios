//
//  UIBarButtonItem+Action.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Action)

+(UIBarButtonItem *)leftBackBarItemWithAction:(SEL)action target:(id)obj;

@end
