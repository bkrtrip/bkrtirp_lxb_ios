//
//  ReusableHeaderView_myShop.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "ReusableHeaderView_myShop.h"
#import "Global.h"
#import "AppMacro.h"

@interface ReusableHeaderView_myShop()

@property (strong, nonatomic) IBOutlet UIButton *instructionButton;

@end

@implementation ReusableHeaderView_myShop

- (void)awakeFromNib {
    // Initialization code
    [[Global sharedGlobal] setUnderlinedWithText:@"微商运营指导" button:_instructionButton  color:TEXT_4CA5FF];
}

- (IBAction)MicroShopInstructionButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithInstructions)]) {
        [self.delegate supportClickWithInstructions];
    }
}

@end
