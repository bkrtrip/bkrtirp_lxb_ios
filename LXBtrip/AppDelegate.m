//
//  AppDelegate.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "MicroShopViewController.h"
#import "SupplierViewController.h"
#import "AlleyListViewController.h"

#import "LoginViewController.h"
#import "PersonalCenterViewController.h"

#import "AFAppDotNetAPIClient.h"

#import "AppMacro.h"
#import "Global.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialYiXinHandler.h"
#import "UMSocialSinaHandler.h"
#import "APService.h"
#import "UserModel.h"


@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic, assign) int rTimerInterval;
@property (nonatomic, assign) int fTimerInterval;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *locationProvince;
@property (nonatomic, copy) NSString *locationCity;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UMSocialData setAppKey:UMSOCIAL_APP_KEY];

    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_KEY url:SHARE_DEFAULT_URL];
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY url:SHARE_DEFAULT_URL];
    //设置易信Appkey和分享url地址,注意需要引用头文件
    [UMSocialYixinHandler setYixinAppKey:YX_APP_KEY url:SHARE_DEFAULT_URL];
    
    //对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [AFAppDotNetAPIClient sharedClient];
    //登录界面
    
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
    
    
    //JPush setup
    [APService
     registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                         UIUserNotificationTypeSound |
                                         UIUserNotificationTypeAlert)
     categories:nil];
    
    // Required
    [APService setupWithOption:launchOptions];
    
    
    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//        NSLog(@"%@",record);
        
        //        [self showAlertViewWithTitle:@"提示" message:@"收到标准推送通知。" cancelButtonTitle:@"确定"];
        
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NEWSRemoteNotification object:nil];
                
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
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
    
    _locationProvince = [[Global sharedGlobal] locationProvince];
    _locationCity = [[Global sharedGlobal] locationCity];
    
    if (!_locationProvince && !_locationCity) {
        [self startLocation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//APNs call back

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
    
    //    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSString *staffName = [UserModel getUserPropertyByKey:@"staff_name"];
    if (staffName) {
        [APService setTags:[NSSet setWithObject:staffName] alias:staffName callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        //        [APService setTags:[NSSet setWithObject:staffName] callbackSelector:nil object:nil];
    }
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
    //    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
//    NSLog(@"error -- %@",error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    //    [self showAlertViewWithTitle:@"提示" message:@"收到标准推送通知。" cancelButtonTitle:@"确定"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NEWSRemoteNotification object:nil];
//    self.hasNewMessages = YES;
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", userInfo);
    
    //    [self showAlertViewWithTitle:@"提示" message:@"收到标准推送通知。" cancelButtonTitle:@"确定"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NEWSRemoteNotification object:nil];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
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
//        [self stopRTimer];
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
//        [self stopFTimer];
        return NO;
    }
}


#pragma mark - Location Part
//开始定位
- (void)startLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1.0f;
    [_locationManager startUpdatingLocation];
    
    if(![CLLocationManager locationServicesEnabled]){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启定位:设置 > 隐私 > 位置 > 定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        });
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        [_locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
}

#pragma mark - CLLocationManagerDelegate
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
//    NSLog(@"location ok");
    
    CLLocation *newLocation = [locations objectAtIndex:0];
    
//    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    
    // 更新经纬度
    [[Global sharedGlobal] upDateLocationCoordinate:newLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
//            NSLog(@"%@", test);
            NSString *newProvince = [test objectForKey:@"State"];
            NSString *newCity = [test objectForKey:@"City"];
//            NSLog(@"newCity: ------ %@", newCity);
//            NSLog(@"newProvince: ------ %@", newProvince);
            
            if (![_locationProvince isEqualToString:newProvince]) {
                _locationProvince = newProvince;
                [[Global sharedGlobal] upDateLocationProvince:_locationProvince];
//                [[NSNotificationCenter defaultCenter] postNotificationName:PROVINCE_CHANGED object:self];//省份改变
            }
            if (![_locationCity isEqualToString:newCity]) {
                _locationCity = newCity;
                [[Global sharedGlobal] upDateLocationCity:_locationCity];
                [[NSNotificationCenter defaultCenter] postNotificationName:CITY_CHANGED object:self];//城市改变
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLError err = [[error domain] intValue];
    
    if (err == kCLErrorDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启定位:设置 > 隐私 > 位置 > 定位服务 下 旅小宝" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
    
    if ((err != kCLErrorLocationUnknown) && (err != kCLErrorDenied)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UMSocial Callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end









