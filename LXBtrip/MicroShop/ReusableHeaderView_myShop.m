//
//  ReusableHeaderView_myShop.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "ReusableHeaderView_myShop.h"

@interface ReusableHeaderView_myShop()



@end

@implementation ReusableHeaderView_myShop

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)MicroShopInstructionButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithInstructions)]) {
        [self.delegate supportClickWithInstructions];
    }
}

@end
