//
//  AFAppDotNetAPIClient.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
#import "AppMacro.h"
#import "Global.h"

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:HOST_BASE_URL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
//                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORK_AVAILABLE" object:self];
                    [[Global sharedGlobal] setNetworkAvailability:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WWAN" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
//                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORK_AVAILABLE" object:self];
                    [[Global sharedGlobal] setNetworkAvailability:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WiFi" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
//                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORK_UNAVAILABLE" object:self];
                    [[Global sharedGlobal] setNetworkAvailability:NO];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NotReachable" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                }
                    break;
                case AFNetworkReachabilityStatusUnknown:
                {
//                    NSLog(@"-------AFNetworkReachabilityStatusUnknown------");
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unknown" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                }
                    break;
                default:
                    break;
            }
        }];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

@end
