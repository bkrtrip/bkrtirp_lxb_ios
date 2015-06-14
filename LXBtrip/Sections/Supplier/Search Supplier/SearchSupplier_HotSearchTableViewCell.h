//
//  SearchSupplier_HotSearchTableViewCell.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/6.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol SearchSupplier_HotSearchTableViewCell_Delegate <NSObject>

- (void)supportClickHotSearchWithIndex:(NSInteger)index;

@end

@interface SearchSupplier_HotSearchTableViewCell : UITableViewCell

@property (nonatomic, weak) id <SearchSupplier_HotSearchTableViewCell_Delegate> delegate;

- (void)setCellContentWithHotSearchNames:(NSArray *)names;

@end
