//
//  AlleyDetailCell_JoinNum.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailCell_JoinNum.h"

@interface AlleyDetailCell_JoinNum()

@property (strong, nonatomic) IBOutlet UILabel *joinedNumLabel;


@end
@implementation AlleyDetailCell_JoinNum

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithAlleyInfo:(AlleyInfo *)info
{
    _joinedNumLabel.text = info.alleyJoinNum;
}


@end
