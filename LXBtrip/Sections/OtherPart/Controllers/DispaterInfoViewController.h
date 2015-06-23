//
//  DispaterInfoViewController.h
//  LXBtrip
//
//  Created by Sam on 6/14/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBaseViewController.h"

@interface DispaterInfoViewController : NavBaseViewController

@property (assign, nonatomic) BOOL isUpdateDispatcher;

@property (retain, nonatomic) NSDictionary *dispatcherDic;

@end
