//
//  TourDetailWebDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/13.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourDetailWebDetailViewController.h"

@interface TourDetailWebDetailViewController () <UIWebViewDelegate>
{
    NSTimer *loadTimer;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TourDetailWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"线路详情";
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_detailURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(stopLoading) userInfo:nil repeats:NO];
}

- (void)stopLoading
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [_webView stopLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadTimer invalidate];
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
}

@end
