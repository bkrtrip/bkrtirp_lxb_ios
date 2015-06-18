//
//  AlterUserInfoViewController.h
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBaseViewController.h"


@protocol UpdateUserInformationDelegate <NSObject>

- (void)updateUserInformationSuccessfully;

@optional

- (void)informationAlteredTo:(NSString *)changedInfor;

@end


typedef enum : NSUInteger {
    ShopContactName,
    ShopName,
    DetailAdress,
    
    
    //for add or update webchat payment information
    WX_loginname,
    WX_loginpwd,
    WX_appid,
    WX_appsecret,
    WX_partner,
    WX_paysecret
    
    
} AlterInfoTypes;

@interface AlterUserInfoViewController : NavBaseViewController

@property (assign, nonatomic) AlterInfoTypes type;

@property (retain, nonatomic) NSDictionary *userInfoDic;

@property (weak, nonatomic) id<UpdateUserInformationDelegate> delegate;

@end
