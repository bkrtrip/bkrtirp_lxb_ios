//
//  AppDelegate.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"

#import "MicroShopViewController.h"
#import "SupplierViewController.h"
#import "AlleyListViewController.h"

#import "LoginViewController.h"
#import "PersonalCenterViewController.h"

@interface AppDelegate ()

@property (nonatomic, assign) int rTimerInterval;
@property (nonatomic, assign) int fTimerInterval;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //登录界面
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"UserLogin" bundle:nil];
    LoginViewController *loginViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    
    MicroShopViewController *shop = [[MicroShopViewController alloc] init];
    SupplierViewController *supplier = [[SupplierViewController alloc] init];
    AlleyListViewController *alley = [[AlleyListViewController alloc] init];
    
    PersonalCenterViewController *personalCenter = [[PersonalCenterViewController alloc] init];
    
    UINavigationController *shopNav = [[UINavigationController alloc] initWithRootViewController:shop];
    UINavigationController *supplierNav = [[UINavigationController alloc] initWithRootViewController:supplier];
    UINavigationController *alleyNav = [[UINavigationController alloc] initWithRootViewController:alley];
    
    UINavigationController *personalCenterNav = [[UINavigationController alloc] initWithRootViewController:personalCenter];
    
    MainTabBarViewController *tabController = [[MainTabBarViewController alloc] init];
    [tabController setViewControllers:[NSArray arrayWithObjects:shopNav, supplierNav, alleyNav, personalCenterNav, nil]];
    
    self.window.rootViewController = tabController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Timers work
- (BOOL)startRTimer
{
    [self stopRTimer];
    
    self.rTimerInterval = 60;
    self.rTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setRState) userInfo:nil repeats:YES];
    if (nil == self.rTimer) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)stopRTimer
{
    [self.rTimer invalidate];
    self.rTimer = nil;
//    self.delegateForRegister = nil;
}

- (BOOL) setRState
{
    self.rTimerInterval = self.rTimerInterval - 1;
    
    if (self.delegateForRegister && [self.delegateForRegister respondsToSelector:@selector(changeRState:)]) {
        [self.delegateForRegister changeRState:self.rTimerInterval];
        
        if (self.rTimerInterval == 1) {
            [self stopRTimer];
        }
        
        return YES;
    }
    else{
        [self stopRTimer];
        return NO;
    }
}

//forget pwd procedure
- (BOOL)startFTimer
{
    [self stopFTimer];
    
    self.fTimerInterval = 60;
    self.fTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setFState) userInfo:nil repeats:YES];
    if (nil == self.fTimer) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)stopFTimer
{
    [self.fTimer invalidate];
    self.fTimer = nil;
}

- (BOOL)setFState
{
    self.fTimerInterval = self.fTimerInterval - 1;
    
    if (self.delegateForForgetPwd && [self.delegateForForgetPwd respondsToSelector:@selector(changeFState:)]) {
        [self.delegateForForgetPwd changeFState:self.fTimerInterval];
        
        if (self.fTimerInterval == 1) {
            [self stopFTimer];
        }
        
        return YES;
    }
    else{
        [self stopFTimer];
        return NO;
    }
}

@end









