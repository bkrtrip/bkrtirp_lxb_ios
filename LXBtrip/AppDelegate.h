//
//  AppDelegate.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTimerDelegate <NSObject>
@optional
- (void) changeRState:(int)leftSeconds;

@end

@protocol FTimerDelegate <NSObject>
@optional
- (void) changeFState:(int)leftSeconds;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, retain) id <RTimerDelegate> delegateForRegister;
@property (retain, nonatomic) NSTimer *rTimer;

@property (nonatomic, retain) id <FTimerDelegate> delegateForForgetPwd;
@property (retain, nonatomic) NSTimer *fTimer;


- (BOOL)startRTimer;
- (void)stopRTimer;

- (BOOL)startFTimer;
- (void)stopFTimer;


@end

