//
//  AlterUserInfoViewController.h
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBaseViewController.h"

typedef enum : NSUInteger {
    ShopContactName,
    ShopName,
    DetailAdress,
} AlterInfoTypes;

@interface AlterUserInfoViewController : NavBaseViewController

@property (assign, nonatomic) AlterInfoTypes type;

- (void)initailAlterType:(AlterInfoTypes)type forInfomation:(NSString *)info;

@end
