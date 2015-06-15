//
//  InviteSupplierTableViewCell_Fourth.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "InviteSupplierTableViewCell_Fourth.h"

@interface InviteSupplierTableViewCell_Fourth()

@end

@implementation InviteSupplierTableViewCell_Fourth

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)callButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall)]) {
        [self.delegate supportClickWithPhoneCall];
    }
}

- (IBAction)messageButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithShortMessage)]) {
        [self.delegate supportClickWithShortMessage];
    }
}

- (IBAction)qqButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithQQ)]) {
        [self.delegate supportClickWithQQ];
    }
}

- (IBAction)wechatButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithWeChat)]) {
        [self.delegate supportClickWithWeChat];
    }
}




@end
