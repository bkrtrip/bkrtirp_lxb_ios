//
//  AccompanyInfoView.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccompanyInfoView_Delegate <NSObject>

- (void)supportClickWithMoreInstructions;
- (void)supportClickWithPhoneCall;
- (void)supportClickWithShortMessage;

@end

@interface AccompanyInfoView : UIView

@property (nonatomic, weak) id <AccompanyInfoView_Delegate> delegate;

@end
