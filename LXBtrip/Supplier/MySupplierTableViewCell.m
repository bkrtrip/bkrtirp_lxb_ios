//
//  MySupplierTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MySupplierTableViewCell.h"

@interface MySupplierTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineClassLabel;

@end

@implementation MySupplierTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContentWithSupplierInfo:(SupplierInfo *)info
{
    _supplierNameLabel.text = info.supplierName;
    _lineClassLabel.text = info.supplierLineType;
}

















@end
