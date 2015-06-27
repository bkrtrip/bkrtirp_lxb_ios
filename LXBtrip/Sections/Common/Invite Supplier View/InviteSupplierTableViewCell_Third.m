//
//  InviteSupplierTableViewCell_Third.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "InviteSupplierTableViewCell_Third.h"

@interface InviteSupplierTableViewCell_Third()

@property (strong, nonatomic) IBOutlet UIButton *customerServicePhoneNoButton;

@end

@implementation InviteSupplierTableViewCell_Third

- (void)awakeFromNib {
    // Initialization code
    [self setUnderlinedButtonWithText:@"400-9979-029"];
}

- (void)setCellContentWithPhoneNumber:(NSString *)number
{
    [self setUnderlinedButtonWithText:number];
}

- (void)setUnderlinedButtonWithText:(NSString *)text
{
    if (text) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [_customerServicePhoneNoButton setAttributedTitle:str forState:UIControlStateNormal];
    }
}

- (IBAction)hotLineButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://4009979029"]]];
}
@end
