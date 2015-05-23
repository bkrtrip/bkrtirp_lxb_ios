//
//  MicroShopCollectionViewCell_MyShop.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/24.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface MicroShopCollectionViewCell_MyShop : UICollectionViewCell

- (void)setCellContentWithMicroShopInfo:(MicroShopInfo *)info isLock:(NSInteger)isLock isDefault:(NSInteger)isDefault;


@end
