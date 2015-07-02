//
//  TourDetailCell_Three.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Three.h"
#import "Global.h"

@interface TourDetailCell_Three()

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@end
@implementation TourDetailCell_Three

- (void)awakeFromNib {
    // Initialization code
    }

- (void)setCellContentWithStartDate:(NSString *)startDate
{
    if (startDate) {
        _startDateLabel.text = [NSString stringWithFormat:@"%@ %@", startDate, [[Global sharedGlobal] weekDayFromDateString:startDate]];
    }
}


@end
