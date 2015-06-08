//
//  AlleyDetailCell_Instruction.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailCell_Instruction.h"

@interface AlleyDetailCell_Instruction()

@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;


@end

@implementation AlleyDetailCell_Instruction

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithAlleyInfo:(AlleyInfo *)info
{
    _instructionsLabel.text = info.alleyServiceNotice;
}

@end
