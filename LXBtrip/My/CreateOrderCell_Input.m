//
//  CreateOrderCell_Input.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_Input.h"

@interface CreateOrderCell_Input()

@property (strong, nonatomic) IBOutlet UILabel *inputTypeLabel;

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation CreateOrderCell_Input

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
