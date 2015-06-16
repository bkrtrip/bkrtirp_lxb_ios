//
//  InviteSupplierTableViewCell_First.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "InviteSupplierTableViewCell_First.h"

@interface InviteSupplierTableViewCell_First()

@property (strong, nonatomic) IBOutlet UILabel *invitationCodeLabel;

@end

@implementation InviteSupplierTableViewCell_First

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithInvitationCode:(NSString *)code
{
    if (code) {
        _invitationCodeLabel.text = [NSString stringWithFormat:@"[邀请码：%@]", code];
    }
}
@end
