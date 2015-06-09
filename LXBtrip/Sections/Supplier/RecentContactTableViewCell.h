//
//  RecentContactTableViewCell.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentContactButton.h"

@protocol RecentContactTableViewCell_Delegate <NSObject>

- (void)supportClickWithRecentContactSupplierIndex:(NSInteger)index;

@end

@interface RecentContactTableViewCell : UITableViewCell

@property (nonatomic, weak) id <RecentContactTableViewCell_Delegate> delegate;

- (void)setCellContentWithSupplierInfos:(NSArray *)suppliers;

@end
