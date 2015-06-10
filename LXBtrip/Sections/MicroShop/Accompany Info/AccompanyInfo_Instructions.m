//
//  AccompanyInfo_Instructions.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AccompanyInfo_Instructions.h"

@interface AccompanyInfo_Instructions()

@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;
@end

@implementation AccompanyInfo_Instructions

- (void)awakeFromNib {
    // Initialization code
}

- (CGFloat)cellHeightWithInstructions:(NSString *)instructions
{
    CGFloat cellHeight = 55.f + 10.f;
    _instructionsLabel.text = instructions;
    CGSize instructionSize = [_instructionsLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2*8, MAXFLOAT)];

    cellHeight += instructionSize.height;
    
    return cellHeight;
    
}


@end
