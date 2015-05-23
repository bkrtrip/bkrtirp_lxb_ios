//
//  ReusableHeaderView_myShop.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReusableHeaderView_myShop_Delegate<NSObject>

- (void)supportClickWithInstructions;

@end

@interface ReusableHeaderView_myShop : UICollectionReusableView

@property (nonatomic, weak) id <ReusableHeaderView_myShop_Delegate>delegate;

@end
