//
//  SearchSupplier_SearchLineClassTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplier_SearchLineClassTableViewCell.h"

@interface SearchSupplier_SearchLineClassTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *lineClassLabel;

@end

@implementation SearchSupplier_SearchLineClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellContentWithLineClassName:(NSString *)name
{
    _lineClassLabel.text = name;
}

@end
