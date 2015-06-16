//
//  CreateOrderCell_Input.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol CreateOrderCell_Input_Delegate <NSObject>

- (void)setEditingCellIndexWithIndexPath:(NSIndexPath *)indexPath;
- (void)setEditingCellTextWithText:(NSString *)text;
- (void)supportClickWithPreviousIndexPath:(NSIndexPath *)curIndexPath;
- (void)supportClickWithNextIndexPath:(NSIndexPath *)curIndexPath;

@end

@interface CreateOrderCell_Input : UITableViewCell

@property (nonatomic, weak) id <CreateOrderCell_Input_Delegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
- (void)setCellContentWithInputType:(NSString *)type section:(NSInteger)section row:(NSInteger)row;

@end
