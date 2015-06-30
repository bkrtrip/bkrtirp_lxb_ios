//
//  AlleyDetailCell_Top.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailCell_Top.h"

@interface AlleyDetailCell_Top()

@property (strong, nonatomic) IBOutlet UIImageView *alleyImageView;
@property (strong, nonatomic) IBOutlet UILabel *alleyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerLabel;
@property (strong, nonatomic) IBOutlet UILabel *certificateLabel;

@property (strong, nonatomic) AlleyInfo *alley;

@end


@implementation AlleyDetailCell_Top

- (void)awakeFromNib {
    _alleyImageView.layer.cornerRadius = _alleyImageView.frame.size.height/2.0;
    _alleyImageView.layer.masksToBounds = YES;
}

- (void)setCellContentWithAlleyInfo:(AlleyInfo *)info
{
    _alley = info;
    
    NSString *logoString = [NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.alleyLogo];
    
    [_alleyImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:ImageNamed(@"default_logo") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _alleyNameLabel.text = info.alleyName;
    _providerLabel.text = info.alleyBrand;
    if (info.alleyCompanyBusinessLicense) {
        _certificateLabel.text = [NSString stringWithFormat:@"许可证号: %@", info.alleyCompanyBusinessLicense];
        _certificateLabel.hidden = NO;
    } else {
        _certificateLabel.hidden = YES;
    }
}

@end
