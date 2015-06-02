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
@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;

@end

@implementation SupplierCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    SupplierStatus status = -1;
    if (info.supplierIsMy && [info.supplierIsMy intValue] == 0) {
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
        case 0:
            [_bgImageView setImage:ImageNamed(@"is_my_and_is_new")];
            break;
        case 1:
            [_bgImageView setImage:ImageNamed(@"is_my")];
            break;
        case 2:
            [_bgImageView setImage:ImageNamed(@"is_new")];
            break;
        case 3:
            [_bgImageView setImage:ImageNamed(@"not_my_and_not_new")];
            break;
        default:
            break;
    }
    _supplierNameLabel.text = info.supplierName;
}


@end
