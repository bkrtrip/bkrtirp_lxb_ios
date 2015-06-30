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

- (CGFloat)cellHeightWithAlleyInfo:(AlleyInfo *)info distance:(CGFloat)distance
{
    CGFloat cellHeight = 64.f;
    if (distance > 1000.f) {
        [_locationButton setTitle:[NSString stringWithFormat:@"%.1f千米以内", distance/1000.f] forState:UIControlStateNormal];
    } else {
        [_locationButton setTitle:[NSString stringWithFormat:@"%.0f米以内", distance] forState:UIControlStateNormal];
    }
    
    _locationLabel.text = info.alleyCompanyAddress;
    CGSize locationLabelSize = [_locationLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 98.f - 8.f, MAXFLOAT)];
    
    cellHeight += locationLabelSize.height>18.f?(locationLabelSize.height-18.f):0.f;
    
    return cellHeight;
}


@end
