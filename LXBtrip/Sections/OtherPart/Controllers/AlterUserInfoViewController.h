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
    
    
    //for add or update webchat payment information
    WX_loginname,
    WX_loginpwd,
    WX_appid,
    WX_appsecret,
    WX_partner,
    WX_paysecret,
    
    
    //for altering profit rate
    DispatchRate
    
    
} AlterInfoTypes;

@protocol UpdateUserInformationDelegate <NSObject>

@optional

- (void)updateUserInformationSuccessfully;


- (void)informationAlteredTo:(NSString *)changedInfor forType:(AlterInfoTypes)type;

@end

@interface AlterUserInfoViewController : NavBaseViewController

@property (assign, nonatomic) AlterInfoTypes type;

//for alter user info
@property (retain, nonatomic) NSDictionary *userInfoDic;

//for alter webchat payment configuration
@property (retain, nonatomic) NSDictionary *webChatPaymentConfigDic;

//for altering profit rate
@property (retain, nonatomic) NSDictionary * dispatchSettingDic;

@property (weak, nonatomic) id<UpdateUserInformationDelegate> delegate;

@end
