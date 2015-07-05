
//
//  AddShopCollectionViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AddShopCollectionViewCell.h"
#import "AppMacro.h"

@interface AddShopCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *addCellImageView;

@end

@implementation AddShopCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _addCellImageView.layer.borderColor = TEXT_CCCCD2.CGColor;
    _addCellImageView.layer.borderWidth = 0.5f;
}

@end
