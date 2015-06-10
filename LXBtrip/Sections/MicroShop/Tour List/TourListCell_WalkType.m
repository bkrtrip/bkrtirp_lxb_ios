//
//  TourListCell_WalkType.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListCell_WalkType.h"

@interface TourListCell_WalkType()

@property (strong, nonatomic) IBOutlet UILabel *walkTypeLabel;
@end

@implementation TourListCell_WalkType

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContentWithWalkType:(NSString *)walkType textColor:(UIColor *)color
{
    _walkTypeLabel.text = walkType;
    if (color) {
        _walkTypeLabel.textColor = color;
    }
}


@end
