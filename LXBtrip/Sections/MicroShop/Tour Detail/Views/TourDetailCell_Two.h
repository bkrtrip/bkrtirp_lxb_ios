//
//  TourDetailCell_Two.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol TourDetailCell_Two_Delegate <NSObject>

- (void)supportClickWithPhoneCall;
- (void)supportClickWithMoreInstructions;


@end

@interface TourDetailCell_Two : UITableViewCell

@property (nonatomic, weak) id <TourDetailCell_Two_Delegate> delegate;

- (CGFloat)cellHeightWithSupplierProduct:(SupplierProduct *)product startDate:(NSString *)dateString;


@end
