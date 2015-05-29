//
//  TabBarButton.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/30.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TabBarButton.h"
#import "AppMacro.h"

@implementation TabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:TEXT_999999 forState:UIControlStateNormal];
        [self setTitleColor:RED_FF0075 forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:12.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height*0.7, self.frame.size.width, 12);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height*0.1, self.frame.size.width, self.frame.size.height*0.4);
}




@end
