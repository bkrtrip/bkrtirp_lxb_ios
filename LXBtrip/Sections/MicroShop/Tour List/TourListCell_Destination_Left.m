//
//  TourListCell_Destination.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListCell_Destination_Left.h"

@interface TourListCell_Destination_Left()

@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@end

@implementation TourListCell_Destination_Left

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
