//
//  SupplierDetailTopImageTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierDetailTopImageTableViewCell.h"

@interface SupplierDetailTopImageTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *supplierImageView;
@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *providerLabel;
@property (strong, nonatomic) IBOutlet UILabel *certificateLabel;

@property (strong, nonatomic) SupplierInfo *info;


@end

@implementation SupplierDetailTopImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _supplierImageView.layer.cornerRadius = _supplierImageView.frame.size.height/2.0;
    _supplierImageView.layer.masksToBounds = YES;
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    _info = info;
    
    NSString *logoString = [NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.supplierLogo];
    
    [_supplierImageView sd_setImageWithURL:[NSURL URLWithString:logoString] placeholderImage:ImageNamed(@"default_logo") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    _supplierNameLabel.text = info.supplierName;
    _providerLabel.text = info.supplierBrand;
    
    if (info.alleyCompanyBusinessLicense) {
        _certificateLabel.text = [NSString stringWithFormat:@"许可证号: %@", info.alleyCompanyBusinessLicense];
        _certificateLabel.hidden = NO;
    } else {
        _certificateLabel.hidden = YES;
    }
}

@end
