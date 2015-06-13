//
//  TourDetailCell_Four.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/28.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@protocol TourDetailCell_Four_Delegate <NSObject>

- (void)supportClickWithDetail;
- (void)supportClickWithTravelTourGuide;
- (void)supportClickWithReviews;

@end

@interface TourDetailCell_Four : UITableViewCell

@property (nonatomic, weak) id <TourDetailCell_Four_Delegate> delegate;

@end
