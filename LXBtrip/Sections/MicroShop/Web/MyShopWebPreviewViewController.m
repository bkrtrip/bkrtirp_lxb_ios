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
@property (strong, nonatomic) IBOutlet UIWebView *webView;

// http://mobile.bkrtrip.com/line/custom/@companyid/@staffid/@customid?tpd=@templateid

@end

@implementation MyShopWebPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"线路详情";
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_ShopURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.f]];
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"http://mobile.bkrtrip.com/line/custom/@companyid/@staffid/@customid?tpd=@templateid"]) {
        TourListViewController *tourList = [[TourListViewController alloc] init];
        tourList.templateId = @0;
        tourList.customId = @"";
        [self.navigationController pushViewController:tourList animated:YES];
    }
    
    return NO;
    
//    if (request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"http://mobile.bkrtrip.com/line/custom/@%@/@%@/@c%@?tpd=@%@", [UserModel companyId], [UserModel staffId], ]) {
//        
//    }

}




@end
