//
//  MySupplierTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MySupplierTableViewCell.h"

@interface MySupplierTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *supplierLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineClassLabel;

@end

@implementation MySupplierTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    [_supplierLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, info.supplierLogo]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _supplierNameLabel.text = info.supplierBrand;
    _lineClassLabel.text = info.supplierLineType;
}

@end
