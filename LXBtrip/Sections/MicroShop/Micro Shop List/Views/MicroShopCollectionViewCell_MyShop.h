//
//  MicroShopCollectionViewCell_MyShop.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol MicroShopCollectionViewCell_MyShop_Delegate <NSObject>

- (void)supportClickWithDeleteShopId:(NSNumber *)shopId;

@end

@interface MicroShopCollectionViewCell_MyShop : UICollectionViewCell

@property (nonatomic, weak) id <MicroShopCollectionViewCell_MyShop_Delegate>delegate;

- (void)setCellContentWithMicroShopInfo:(MicroShopInfo *)info;


@end
