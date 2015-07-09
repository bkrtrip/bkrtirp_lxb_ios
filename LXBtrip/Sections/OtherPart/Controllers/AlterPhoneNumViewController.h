//
//  AlterPhoneNumViewController.h
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBaseViewController.h"
#import "AlterUserInfoViewController.h"

@interface AlterPhoneNumViewController : NavBaseViewController

@property (nonatomic, retain) NSDictionary *userInfoDic;

@property (weak, nonatomic) id<UpdateUserInformationDelegate> delegate;

@end
