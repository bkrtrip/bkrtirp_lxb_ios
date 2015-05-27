//
//  UIBarButtonItem+Action.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "UIBarButtonItem+Action.h"

@implementation UIBarButtonItem(Action)

+(UIBarButtonItem *)leftBackBarItemWithAction:(SEL)action target:(id)obj
{
    UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.frame = CGRectMake(0, 0, 44, 44);
    [item setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal ];
    [item addTarget:obj action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:item];
}

@end
