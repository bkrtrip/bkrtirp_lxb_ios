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

- (CGFloat)cellHeightWithAlleyInfo:(AlleyInfo *)info
{
    CGFloat cellHeight = 45.f;
    _instructionsLabel.text = info.alleyServiceNotice;
    CGSize instructionSize = [_instructionsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8, MAXFLOAT)];
    cellHeight += instructionSize.height;
    
    return cellHeight;
}

@end
