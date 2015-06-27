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
    CGFloat cellHeight = 64.f;
    _locationLabel.text = info.alleyCompanyAddress;
    CGSize locationLabelSize = [_locationLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 98.f - 8.f, MAXFLOAT)];
    
    cellHeight += locationLabelSize.height>18.f?(locationLabelSize.height-18.f):0.f;
    
    return cellHeight;
}


@end
