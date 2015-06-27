//
//  AlleyListCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyListCollectionViewCell.h"

@interface AlleyListCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *alleyLogoImageview;
@property (strong, nonatomic) IBOutlet UILabel *alleyNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *alleyLocationButton;

@end

@implementation AlleyListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithAlleyInfo:(AlleyInfo *)alley
{
    [_alleyLogoImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, alley.alleyLogo]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];

    _alleyNameLabel.text = alley.alleyBrand;
    
//    _alleyNameLabel.text = alley.alleyName;
//    [_alleyLocationButton setTitle:alley.alleyLocation forState:UIControlStateNormal];
}



@end
