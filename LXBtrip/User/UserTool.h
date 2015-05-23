//
//  UserTool.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/12.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"
@class User;
@interface UserTool : NSObject
singleton_interface(UserTool)
/*
 *保存用户
 */
-(void)saveUser:(User *)user;
/*
 *访问用户
 */
@property (strong,nonatomic,readonly)User *user;
@end


