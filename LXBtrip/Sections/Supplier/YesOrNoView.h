//
//  YesOrNoView.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/2.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YesOrNoViewDelegate <NSObject>

- (void)supportClickWithNo;
- (void)supportClickWithYes;

@end

@interface YesOrNoView : UIView
@property (nonatomic, weak) id <YesOrNoViewDelegate> delegate;

- (void)setYesOrNoViewWithIntroductionString:(NSString *)introString confirmString:(NSString *)confString;

@end
