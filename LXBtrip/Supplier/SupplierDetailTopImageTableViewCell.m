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

@end

@implementation SupplierDetailTopImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    NSString *logoString = [NSString stringWithFormat:@"%@_logo", info.supplierLogo];
    
    [_supplierImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, logoString]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    _supplierNameLabel.text = info.supplierName;
    _providerLabel.text = info.supplierBrand;
}


- (IBAction)messageButtonClicked:(id)sender {
}

- (IBAction)phoneButtonClicked:(id)sender {
}







@end
