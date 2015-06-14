//
//  AlleyDetailCell_Location.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailCell_Location.h"

@interface AlleyDetailCell_Location()

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;


@end
@implementation AlleyDetailCell_Location

- (void)awakeFromNib {
    // Initialization code
}

- (CGFloat)cellHeightWithAlleyInfo:(AlleyInfo *)info
{
    _locationLabel.text = info.alleyCompanyAddress;
    return 70.f;
}


@end
