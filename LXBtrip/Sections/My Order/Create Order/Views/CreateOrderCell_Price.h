//
//  CreateOrderCell_Price.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol CreateOrderCell_Price_Delegate <NSObject>

- (void)supportClickPlusOrMinusWithDeltaNum:(NSInteger)num touristType:(TouristType)type;

@end

@interface CreateOrderCell_Price : UITableViewCell

@property (nonatomic, weak) id <CreateOrderCell_Price_Delegate>delegate;
- (void)setCellContentWithOrder:(MyOrderItem *)order touristType:(TouristType)type shouldShowGraySeparator:(BOOL)showSeparator;

@end
