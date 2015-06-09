//
//  InfoConfigTableViewCell.m
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "InfoConfigTableViewCell.h"

@interface InfoConfigTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation InfoConfigTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeUIStateForType:(ConfigType)type
{
    
}

- (void)initializeCellForType:(ConfigContentType)type
{
    switch (type) {
        case WCPublicUserName:
        {
            self.titleLabel.text = @"微信公众平台用户名";
        }
            break;
        case WCPwd:
        {
            self.titleLabel.text = @"微信密码";
        }
            break;
        case PublicAppId:
        {
            self.titleLabel.text = @"公众号appid";
        }
            break;
        case PublicSecret:
        {
            self.titleLabel.text = @"公众号appsecret";
        }
            break;
        case WCPayAcount:
        {
            self.titleLabel.text = @"微信支付商户号";
        }
            break;
        case WCPaySecret:
        {
            self.titleLabel.text = @"支付密钥";
        }
            break;
            
        default:
            break;
    }
}

- (void)setcontentInformation:(NSString *)content
{
    if (content && content.length > 0) {
        self.contentLabel.text = content;
    }
}


@end










