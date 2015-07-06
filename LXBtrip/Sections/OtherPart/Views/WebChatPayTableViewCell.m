//
//  WebChatPayTableViewCell.m
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "WebChatPayTableViewCell.h"

@interface WebChatPayTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *openStateLabel;

@end

@implementation WebChatPayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changePayOpenState:(BOOL)isOpened
{
    if (isOpened) {
        self.openStateLabel.text = @"已开通";
    }
    else {
        self.openStateLabel.text = @"未开通";
    }
}

@end
