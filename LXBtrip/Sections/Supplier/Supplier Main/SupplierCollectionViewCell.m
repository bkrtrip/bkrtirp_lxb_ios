//
//  SupplierCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierCollectionViewCell.h"

@interface SupplierCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UILabel *supplierBrandLabel;

@end

@implementation SupplierCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    SupplierStatus status;
    if (!info) {
        status = -1;
    } else if (info.supplierIsMy && [info.supplierIsMy intValue] == 0) {
        if (info.supplierIsNew && [info.supplierIsNew intValue] == 0) {
            status = 0;
        } else {
            status = 1;
        }
    } else {
        if (info.supplierIsNew && [info.supplierIsNew intValue] == 0) {
            status = 2;
        } else {
            status = 3;
        }
    }
    
    switch (status) {
        case invite_supplier:
            [_bgImageView setImage:ImageNamed(@"add_new_supplier")];
            break;
        case supplier_isMy_isNew:
            [_bgImageView setImage:ImageNamed(@"is_my_and_is_new")];
            break;
        case supplier_isMy_notNew:
            [_bgImageView setImage:ImageNamed(@"is_my")];
            break;
        case supplier_notMy_isNew:
            [_bgImageView setImage:ImageNamed(@"is_new")];
            break;
        case supplier_notMy_notNew:
            [_bgImageView setImage:ImageNamed(@"not_my_and_not_new")];
            break;
        default:
            break;
    }
    _supplierBrandLabel.text = info.supplierBrand;
}


@end
