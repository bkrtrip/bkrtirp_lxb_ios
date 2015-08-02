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

@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;

@end
@implementation TourDetailCell_Three

- (void)setCellContentWithStartDate:(NSString *)startDate imageView:(UIImage *)image title:(NSString *)title
{
    _cellImageView.image = image;
    _cellTitleLabel.text = title;
    
    if (startDate) {
        _startDateLabel.hidden = NO;
        _startDateLabel.text = [NSString stringWithFormat:@"%@ %@", startDate, [[Global sharedGlobal] weekDayFromDateString:startDate]];
    } else {
        _startDateLabel.hidden = YES;
    }
}


@end
