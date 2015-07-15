//
//  UserModel.m
//  lxb
//
//  Created by Sam on 2/12/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "UserModel.h"

static NSString *userPlistPath = nil;

@interface UserModel ()
@end

@implementation UserModel


+ (NSDictionary *)getUserInformations
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getUserPlistPath]]) {
        
        NSDictionary *userInforDic = [NSDictionary dictionaryWithContentsOfFile:[self getUserPlistPath]];
        return userInforDic;
    }
    
    return nil;
}

+ (void)storeUserInformations:(NSDictionary *)userDic
{
    [self clearUserInformation];
    
//    NSLog(@"userDic: %@", userDic);
    if (userDic) {
        [userDic writeToFile:[self getUserPlistPath] atomically:NO];
    }
}

+ (NSString *)getUserPropertyByKey:(NSString *)key
{
    NSDictionary *userDic = [[self getUserInformations] objectForKey:@"RS100034"];
    
    if (userDic) {
        return [NSString stringWithFormat:@"%@", [userDic objectForKey:key]];
    }
    
    return nil;
}

+ (void)updateUserProperty:(NSString *)property ForKey:(NSString *)key
{
    NSMutableDictionary *userDic1 = [[self getUserInformations] mutableCopy];
    NSMutableDictionary *userDic2 = [userDic1 objectForKey:@"RS100034"];
    [userDic2 setObject:property forKey:key];
    [userDic1 setObject:userDic2 forKey:@"RS100034"];
    [userDic1 writeToFile:[self getUserPlistPath] atomically:NO];
}

+ (void)clearUserInformation
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[self getUserPlistPath]]) {
        NSError *error;
        [fileManager removeItemAtPath:[self getUserPlistPath] error:&error];
        
        if (error) {
//            NSLog(@"remove (%@) failed : %@",[self getUserPlistPath], error.description);
        }
    }
}

+ (NSString *)getUserPlistPath
{
    if (userPlistPath) {
        return userPlistPath;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    userPlistPath = [[paths.firstObject stringByAppendingPathComponent:@"user"] stringByAppendingPathExtension:@"plist"];
    
    return userPlistPath;
}

// newly add
+ (NSNumber *)companyId
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"dat_company_id"];
}
+ (NSNumber *)staffId
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"staff_id"];
}
+ (NSString *)staffRealName
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"staff_real_name"];
}
+ (NSString *)staffDepartmentName
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"staff_departments_name"];
}
+ (NSString *)userToken
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"][@"access_token"] objectForKey:@"token"];
}
+ (NSString *)userName
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"staff_name"];
}

+ (NSString *)inviteCode
{
    NSDictionary *userDic = [self getUserInformations];
    return [userDic[@"RS100034"] objectForKey:@"invite_code"];
}

@end
