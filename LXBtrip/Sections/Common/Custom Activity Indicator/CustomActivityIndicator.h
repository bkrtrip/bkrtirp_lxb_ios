//
//  CustomActivityIndicator.h
//  JieShuQuan
//
//  Created by Yang Xiaozhu on 14-9-21.
//  Copyright (c) 2014年 JNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomActivityIndicator : UIWindow

+ (CustomActivityIndicator *)sharedActivityIndicator;

- (void)startSimpleStyleSynchAnimating;
- (void)stopSimpleStyleSynchAnimating;

- (void)startComplexStyleSynchAnimatingWithMessage:(NSString *)message;
- (void)stopComplexStyleSynchAnimating;

- (void)startSynchAnimating;
- (void)stopSynchAnimating;

@end
