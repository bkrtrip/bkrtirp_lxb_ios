//
//  TourWebPreviewViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/12.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourWebPreviewViewController.h"

@interface TourWebPreviewViewController ()<UIWebViewDelegate>
{
    NSTimer *loadTimer;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TourWebPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"线路预览";
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_tourURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(stopLoading) userInfo:nil repeats:NO];
}

- (void)stopLoading
{
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
    [_webView stopLoading];
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadTimer invalidate];
    [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
}

@end
