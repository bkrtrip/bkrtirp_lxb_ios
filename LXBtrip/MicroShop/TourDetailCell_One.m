//
//  TourDetailCell_One.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_One.h"

@interface TourDetailCell_One()

@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *tourIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tourDescriptionLabel;


@end

@implementation TourDetailCell_One

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
