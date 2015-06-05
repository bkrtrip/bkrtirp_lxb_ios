//
//  SiftSupplierCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/5.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SiftSupplierCollectionViewCell.h"

@interface SiftSupplierCollectionViewCell()

@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;

@end

@implementation SiftSupplierCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSiftLine:(SiftedLine *)siftline
{
    _supplierNameLabel.text = siftline.siftedLineName;
}

@end
