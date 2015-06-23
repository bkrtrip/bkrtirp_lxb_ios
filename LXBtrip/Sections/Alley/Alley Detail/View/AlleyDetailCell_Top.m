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
    
}

- (void)setCellContentWithAlleyInfo:(AlleyInfo *)info
{
    _alley = info;
    
    NSString *logoString = [NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.alleyLogo];
    
    [_alleyImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:ImageNamed(@"default_logo.jpg") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _alleyNameLabel.text = info.alleyName;
    _providerLabel.text = info.alleyBrand;
}


- (IBAction)messageButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", _alley.alleyContactPhoneNo]]];
}

- (IBAction)phoneButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _alley.alleyContactPhoneNo]]];
}
@end
