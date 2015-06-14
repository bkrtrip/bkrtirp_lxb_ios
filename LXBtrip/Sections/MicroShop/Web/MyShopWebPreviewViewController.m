//
//  MyShopWebPreviewViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MyShopWebPreviewViewController.h"
#import "TourListViewController.h"

@interface MyShopWebPreviewViewController ()<UIWebViewDelegate>
{
    NSTimer *loadTimer;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MyShopWebPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"线路详情";
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_ShopURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"request.URL.absoluteString: --- %@", request.URL.absoluteString);
    
    NSString *predicate = [NSString stringWithFormat:@"http://mobile.bkrtrip.com/line/custom/%@/%@/", [UserModel companyId], [UserModel staffId]];
    if ([request.URL.absoluteString hasPrefix:predicate]) {
        
        NSString *infoString = [request.URL.absoluteString substringFromIndex:predicate.length];
        NSArray *infoArray = [infoString componentsSeparatedByString:@"?"];
        NSString *customId;
        NSString *templateId;
        if (infoArray.count == 2) {
            customId = infoArray[0];
            templateId = [infoArray[1] stringByReplacingOccurrencesOfString:@"tpd=" withString:@""];
        }
        
        TourListViewController *tourList = [[TourListViewController alloc] init];
        tourList.templateId = @([templateId integerValue]);
        tourList.customId = customId;
        [self.navigationController pushViewController:tourList animated:YES];
        return NO;
    }
    
    return YES;
}




@end
