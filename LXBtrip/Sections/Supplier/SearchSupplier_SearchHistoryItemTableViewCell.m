//
//  SearchSupplier_SearchHistoryItemTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplier_SearchHistoryItemTableViewCell.h"

@interface SearchSupplier_SearchHistoryItemTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *hotSearchNameLabel;

@end

@implementation SearchSupplier_SearchHistoryItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithSearchHistoryName:(NSString *)name
{
    _hotSearchNameLabel.text = name;
}


@end
