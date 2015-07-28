//
//  SupplierDetailTopImageTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierDetailTopImageTableViewCell.h"
#import "Global.h"

@interface SupplierDetailTopImageTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *supplierImageView;
@property (strong, nonatomic) IBOutlet UIButton *cellPhoneButton;
@property (strong, nonatomic) IBOutlet UIButton *fixedPhoneButton;
- (IBAction)cellPhoneButtonClicked:(id)sender;
- (IBAction)fixedPhoneButtonClicked:(id)sender;

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
    
    if (info.supplierContactMobilePhone && info.supplierContactMobilePhone.length > 0) {
        _cellPhoneButton.hidden = NO;
    } else {
        _cellPhoneButton.hidden = YES;
    }
    
    if (info.supplierContactFixedPhone && info.supplierContactFixedPhone.length > 0) {
        _fixedPhoneButton.hidden = NO;
    } else {
        _fixedPhoneButton.hidden = YES;
    }
    
    _supplierNameLabel.text = info.supplierName;
    _providerLabel.text = info.supplierBrand;
    
    if (info.alleyCompanyBusinessLicense) {
        _certificateLabel.text = [NSString stringWithFormat:@"许可证号: %@", info.alleyCompanyBusinessLicense];
        _certificateLabel.hidden = NO;
    } else {
        _certificateLabel.hidden = YES;
    }
}

- (IBAction)cellPhoneButtonClicked:(id)sender {
    [[Global sharedGlobal] callWithPhoneNumber:_info.supplierContactMobilePhone];
}

- (IBAction)fixedPhoneButtonClicked:(id)sender {
    [[Global sharedGlobal] callWithPhoneNumber:_info.supplierContactFixedPhone];
}
@end
