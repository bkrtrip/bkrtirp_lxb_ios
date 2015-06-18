//
//  TourDetailCell_Three.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailCell_Three.h"

@interface TourDetailCell_Three()

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@end
@implementation TourDetailCell_Three

- (void)awakeFromNib {
    // Initialization code
    }

- (void)setCellContentWithStartDate:(NSString *)startDate weekDay:(NSInteger)weekday;
{
    if (startDate) {
        switch (weekday) {
            case 1:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周日", startDate];
                break;
            case 2:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周一", startDate];
                break;
            case 3:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周二", startDate];
                break;
            case 4:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周三", startDate];
                break;
            case 5:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周四", startDate];
                break;
            case 6:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周五", startDate];
                break;
            case 7:
                _startDateLabel.text = [NSString stringWithFormat:@"%@ 周六", startDate];
                break;
            default:
                break;
        }
    }
}


@end
