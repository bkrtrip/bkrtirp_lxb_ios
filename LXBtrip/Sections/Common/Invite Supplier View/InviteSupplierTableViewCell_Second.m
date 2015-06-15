//
//  InviteSupplierTableViewCell_Second.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "InviteSupplierTableViewCell_Second.h"

@interface InviteSupplierTableViewCell_Second()

@property (strong, nonatomic) IBOutlet UILabel *invitationWordsLabel;

@end

@implementation InviteSupplierTableViewCell_Second

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithInvitationWords:(NSString *)words
{
    _invitationWordsLabel.text = words;
}

@end
