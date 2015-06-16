//
//  CreateOrderCell_Confirm.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_Confirm.h"

@interface CreateOrderCell_Confirm()

@property (strong, nonatomic) IBOutlet UILabel *totalCostLabel;

@end

@implementation CreateOrderCell_Confirm

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithOrder:(MyOrderItem *)order
{
    _totalCostLabel.text = [NSString stringWithFormat:@"￥%@", order.orderDealPrice];
}

- (IBAction)confirmOrderButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickConfirmModification)]) {
        [self.delegate supportClickConfirmModification];
    }
}



@end
