//
//  AccompanyInfoCell_Company.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/10.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AccompanyInfoCell_Company.h"

@interface AccompanyInfoCell_Company()

@property (strong, nonatomic) IBOutlet UILabel *supplierNameLabel;


@end

@implementation AccompanyInfoCell_Company

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContentWithSupplierName:(NSString *)supplierName
{
    _supplierNameLabel.text = supplierName;
}

- (IBAction)phoneButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithPhoneCall)]) {
        [self.delegate supportClickWithPhoneCall];
    }
}

@end
