//
//  SwitchCityTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SwitchCityTableViewCell.h"
#import "AppMacro.h"

@interface SwitchCityTableViewCell()

@property (strong, nonatomic) IBOutlet UIButton *cityButton;

@end

@implementation SwitchCityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _cityButton.userInteractionEnabled = NO;
}

- (void)setCellCityWithName:(NSString *)name isLocationCity:(BOOL)isLocationCity selectedStatus:(BOOL)selected 
{
    if (isLocationCity) {
        [_cityButton setImage:ImageNamed(@"location_red") forState:UIControlStateSelected];
        [_cityButton setTitle:name forState:UIControlStateSelected];
        [_cityButton setSelected:YES];
        return;
    }
    
    if (selected) {
        [_cityButton setTitle:name forState:UIControlStateSelected];
    } else {
        [_cityButton setTitle:name forState:UIControlStateNormal];
    }
    [_cityButton setSelected:selected];
}

@end
