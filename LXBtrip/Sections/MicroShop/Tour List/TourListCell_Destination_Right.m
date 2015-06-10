//
//  TourListCell_Destination_Right.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListCell_Destination_Right.h"

@interface TourListCell_Destination_Right()

@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@end

@implementation TourListCell_Destination_Right

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_destinationButton setSelected:selected];
}

- (void)setCellContentWithDestination:(NSString *)destination
{
    [_destinationButton setTitle:destination forState:UIControlStateNormal];
    [_destinationButton setTitle:destination forState:UIControlStateSelected];
}


@end
