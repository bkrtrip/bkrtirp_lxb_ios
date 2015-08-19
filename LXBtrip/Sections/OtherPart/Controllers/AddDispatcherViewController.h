//
//  AddDispatcherViewController.h
//  LXBtrip
//
//  Created by Sam on 6/22/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBaseViewController.h"

@protocol AddOrUpdateDispaterComplete <NSObject>

- (void)finishAddOrUpdateDispater;

@end

@interface AddDispatcherViewController : NavBaseViewController

@property (assign, nonatomic) BOOL isAlterDispatcher;
@property (retain, nonatomic) NSDictionary *dispatcherInfoDic;
@property (weak, nonatomic) id<AddOrUpdateDispaterComplete> delegate;

@end
