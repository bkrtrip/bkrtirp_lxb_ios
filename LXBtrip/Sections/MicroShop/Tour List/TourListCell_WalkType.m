//
//  TourListCell_WalkType.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/12.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListCell_WalkType.h"

@interface TourListCell_WalkType()

@property (strong, nonatomic) IBOutlet UIButton *walkTypeButton;

@end

@implementation TourListCell_WalkType

- (void)awakeFromNib {
    // Initialization code
    _walkTypeButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_walkTypeButton setSelected:selected];
}

- (void)setCellContentWithWalkType:(NSString *)walkType
{
    [_walkTypeButton setTitle:walkType forState:UIControlStateNormal];
    [_walkTypeButton setTitle:walkType forState:UIControlStateSelected];
}


@end
