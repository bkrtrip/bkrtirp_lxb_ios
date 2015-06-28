//
//  CreateOrderCell_StartDate.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_StartOrEndDate.h"
#import "Global.h"

@interface CreateOrderCell_StartOrEndDate()

@property (strong, nonatomic) IBOutlet UILabel *startOrEndTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *startOrEndDateLabel;

@end

@implementation CreateOrderCell_StartOrEndDate

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithTitle:(NSString *)title date:(NSString *)date dateColor:(UIColor *)color
{
    _startOrEndTitleLabel.text = title;
    _startOrEndDateLabel.text = [NSString stringWithFormat:@"%@ %@", date, [[Global sharedGlobal] weekDayFromDateString:date]];
    _startOrEndDateLabel.textColor = color;
}


@end
