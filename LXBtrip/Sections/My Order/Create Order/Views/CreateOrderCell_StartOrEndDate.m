//
//  CreateOrderCell_StartDate.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_StartOrEndDate.h"

@interface CreateOrderCell_StartOrEndDate()

@property (strong, nonatomic) IBOutlet UILabel *startOrEndTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *startOrEndDateLabel;

@end

@implementation CreateOrderCell_StartOrEndDate

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithTitle:(NSString *)title date:(NSString *)date
{
    _startOrEndTitleLabel.text = title;
    _startOrEndDateLabel.text = date;
}

@end
