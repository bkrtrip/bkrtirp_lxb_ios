//
//  SearchSupplier_HotSearchTableViewCell.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SearchSupplier_HotSearchTableViewCell.h"

@interface SearchSupplier_HotSearchTableViewCell()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotSearchButtonsArray;


- (IBAction)hotSearchButtonClicked:(id)sender;

@end

@implementation SearchSupplier_HotSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_hotSearchButtonsArray enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL *stop) {
        bt.tag = idx;
        [bt setTitle:@"" forState:UIControlStateNormal];
    }];
}

- (void)setCellContentWithHotSearchNames:(NSArray *)names
{
    [_hotSearchButtonsArray enumerateObjectsUsingBlock:^(UIButton *bt, NSUInteger idx, BOOL *stop) {
        if (names.count > idx) {
            [bt setTitle:names[idx] forState:UIControlStateNormal];
        }
    }];
}


- (IBAction)hotSearchButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickHotSearchWithIndex:)]) {
        [self.delegate supportClickHotSearchWithIndex:[sender tag]];
    }
}
@end
