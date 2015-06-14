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

@property (strong, nonatomic) NSMutableArray *recentContactButtonsArray;

@end

@implementation RecentContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
    if (!_recentContactButtonsArray) {
        _recentContactButtonsArray = [[NSMutableArray alloc] init];
    }
    CGFloat btWidth = SCREEN_WIDTH/3.f;
    CGFloat btHeight = self.frame.size.height/2.f;
    
    for (int i = 0; i < 6; i++) {
        RecentContactButton *bt = [[NSBundle mainBundle] loadNibNamed:@"RecentContactButton" owner:nil options:nil][0];
        [bt setFrame:CGRectMake((i%3)*btWidth, (i/3)*btHeight, btWidth, btHeight)];
        bt.tag = i;
        [self.contentView addSubview:bt];
        [_recentContactButtonsArray addObject:bt];
    }
}

- (void)setCellContentWithSupplierInfos:(NSArray *)suppliers
{
    [_recentContactButtonsArray enumerateObjectsUsingBlock:^(RecentContactButton *bt, NSUInteger idx, BOOL *stop) {
        if (suppliers.count > idx) {
            SupplierInfo *curInfo = suppliers[idx];
            [bt setRecentContactButtonWithSupplierName:curInfo.supplierBrand lineClass:curInfo.supplierLineType];
//            bt.tag = idx;
            [bt addTarget:self action:@selector(goToSupplierPage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

- (void)goToSupplierPage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(supportClickWithRecentContactSupplierIndex:)]) {
        [self.delegate supportClickWithRecentContactSupplierIndex:[sender tag]];
    }
}













@end
