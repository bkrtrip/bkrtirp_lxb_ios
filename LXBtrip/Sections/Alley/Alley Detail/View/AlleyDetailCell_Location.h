//
//  AlleyDetailCell_Location.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface AlleyDetailCell_Location : UITableViewCell

- (CGFloat)cellHeightWithAlleyInfo:(AlleyInfo *)info distance:(CGFloat)distance;

@end
