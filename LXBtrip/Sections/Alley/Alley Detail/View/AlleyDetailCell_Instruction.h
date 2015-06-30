//
//  AlleyDetailCell_Instruction.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol AlleyDetailCell_Instruction_Delegate <NSObject>

- (void)instructionCellFinishedLoadingWithHeight:(CGFloat)height;

@end

@interface AlleyDetailCell_Instruction : UITableViewCell

@property (nonatomic, weak) id <AlleyDetailCell_Instruction_Delegate> delegate;
- (void)setCellContentWithAlleyInfo:(AlleyInfo *)info;

@end
