//
//  SwitchCityTableViewCell.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCityTableViewCell : UITableViewCell

- (void)setCellCityWithName:(NSString *)name isLocationCity:(BOOL)isLocationCity selectedStatus:(BOOL)selected;

@end
