//
//  TourListCell_WalkType.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListCell_Destination.h"

@interface TourListCell_Destination()

@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@end

@implementation TourListCell_Destination

- (void)awakeFromNib {
    // Initialization code
    _destinationButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [_destinationButton setSelected:selected];
}

- (void)setCellContentWithDestination:(NSString *)destination;
{
    [_destinationButton setTitle:destination forState:UIControlStateNormal];
    [_destinationButton setTitle:destination forState:UIControlStateSelected];
}


@end
