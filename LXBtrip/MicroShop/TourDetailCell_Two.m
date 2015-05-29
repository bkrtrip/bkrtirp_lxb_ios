//
//  TourDetailCell_Two.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Two.h"

@interface TourDetailCell_Two()

@property (strong, nonatomic) IBOutlet UILabel *providerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPerBedPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;

@end


@implementation TourDetailCell_Two

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)moreInstructionsButtonClicked:(id)sender {
}

@end
