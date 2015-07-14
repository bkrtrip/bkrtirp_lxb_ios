//
//  PCommonTableViewCell.m
//  lxb
//
//  Created by Sam on 6/4/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "PCommonTableViewCell.h"

@implementation PCommonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initailCellWithType:(SettingsType)type
{
    switch (type) {
        case Message:
            self.settingIconImgView.image = [UIImage imageNamed:@"msg"];
            self.settingTitleLabel.text = @"消息";
            break;
        case Alipay:
            self.settingIconImgView.image = [UIImage imageNamed:@"alipay"];
            self.settingTitleLabel.text = @"支付";
            break;
        case Dispatch:
            self.settingIconImgView.image = [UIImage imageNamed:@"dispatch"];
            self.settingTitleLabel.text = @"分销";
            break;
        case Help:
            self.settingIconImgView.image = [UIImage imageNamed:@"help"];
            self.settingTitleLabel.text = @"帮助";
            break;
        case About:
            self.settingIconImgView.image = [UIImage imageNamed:@"about"];
            self.settingTitleLabel.text = @"关于旅小宝";
            break;
        case SignOut:
            self.settingIconImgView.image = [UIImage imageNamed:@"signOut"];
            self.settingTitleLabel.text = @"退出登录";
            break;
        case Invitation:
            self.settingIconImgView.image = [UIImage imageNamed:@"invitation"];
            self.settingTitleLabel.text = @"邀请朋友";
            break;
            
        default:
            break;
    }
}

@end
