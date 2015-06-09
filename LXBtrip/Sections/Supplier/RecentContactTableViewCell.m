//
//  RecentContactTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "RecentContactTableViewCell.h"
#import "AppMacro.h"

@interface RecentContactTableViewCell()
@property (strong, nonatomic) IBOutletCollection(RecentContactButton) NSArray *recentContactButtonsArray;

@end

@implementation RecentContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_recentContactButtonsArray enumerateObjectsUsingBlock:^(RecentContactButton *bt, NSUInteger idx, BOOL *stop) {
        bt = [[NSBundle mainBundle] loadNibNamed:@"RecentContactButton" owner:nil options:nil][0];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContentWithSuppliersNames:(NSArray *)names lineClasses:(NSArray *)lineClasses
{
    [_recentContactButtonsArray enumerateObjectsUsingBlock:^(RecentContactButton *bt, NSUInteger idx, BOOL *stop) {
        [bt setRecentContactButtonWithSupplierName:names[idx] lineClass:lineClasses[idx]];
        bt.tag = idx;
        [bt addTarget:self action:@selector(goToSupplierPage:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)setCellContentWithSupplierInfos:(NSArray *)suppliers
{
    [_recentContactButtonsArray enumerateObjectsUsingBlock:^(RecentContactButton *bt, NSUInteger idx, BOOL *stop) {
        SupplierInfo *curInfo = suppliers[idx];
        [bt setRecentContactButtonWithSupplierName:curInfo.supplierName lineClass:curInfo.supplierLineType];
        bt.tag = idx;
        [bt addTarget:self action:@selector(goToSupplierPage:) forControlEvents:UIControlEventTouchUpInside];
    }];
}


- (void)goToSupplierPage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(supportClickWithRecentContactSupplierIndex:)]) {
        [self.delegate supportClickWithRecentContactSupplierIndex:[sender tag]];
    }
}













@end
