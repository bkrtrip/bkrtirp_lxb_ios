//
//  UserModel.h
//  lxb
//
//  Created by Sam on 2/12/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

//get user entire information
+ (NSDictionary *)getUserInformations;

//update user entire information
+ (void)storeUserInformations:(NSDictionary *)userDic;

//get user specific information
+ (NSString *)getUserPropertyByKey:(NSString *)key;

/*
//update user specific information
- (void)updateUserProperty:(NSString *)property ForKey:(NSString *)key;
*/


//clear user information
+ (void)clearUserInformation;


// newly add
+ (NSNumber *)companyId;
+ (NSNumber *)staffId;
+ (NSString *)staffRealName;
+ (NSString *)staffDepartmentName;
+ (NSString *)userToken;
+ (NSString *)userName;
+ (NSString *)inviteCode;
+ (void)updateUserProperty:(NSString *)property ForKey:(NSString *)key;

@end
