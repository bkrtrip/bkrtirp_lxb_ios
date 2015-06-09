//
//  UploadingIconTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/26.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "UploadingIconTableViewCell.h"

@interface UploadingIconTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation UploadingIconTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height/2.0;
    _iconImageView.layer.masksToBounds = YES;
}

- (void)setCellContentWithUserIcon:(UIImage *)icon
{
    [_iconImageView setImage:icon];
}

@end
