//
//  InviteSupplierTableViewCell_Third.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "InviteSupplierTableViewCell_Third.h"
#import "Global.h"
#import "AppMacro.h"

@interface InviteSupplierTableViewCell_Third()

@property (strong, nonatomic) IBOutlet UIButton *customerServicePhoneNoButton;

@end

@implementation InviteSupplierTableViewCell_Third

- (void)awakeFromNib {
    // Initialization code
    [[Global sharedGlobal] setUnderlinedWithText:@"400-9979-029" button:_customerServicePhoneNoButton color:TEXT_4CA5FF];
}

- (IBAction)hotLineButtonClicked:(id)sender {
    [[Global sharedGlobal] callWithPhoneNumber:@"400-9979-029"];
}
@end
